---
title: "Troubleshooting the Azure Standard CDN Rules Engine"
date: "2022-12-10T00:00:00-00:00"
draft: false
tags: ["Azure CDN", "Code"]
summary: "A simple method to troubleshoot rules in the Azure Standard CDN"
hasMermaid: false
---

I was recently updating a few things on this site, including the rewrite/redirect rules that control what content is served. I'd moved this site to an Azure static website a while ago, but had never really set up the redirects properly. I chose to use the standard tier Microsoft CDN, but was frustrated by lack of documentation on how to actually use the rules engine. After pulling my hair out for a few days, I finally realized a way to troubleshoot the rules engine and thought I'd share it here. We'll cover:
- A simple way to test and troubleshoot rules
- Some lessons learned about how the rules engine performs matches
- A few sample rules that I'm using on this site.

If you want to skip to the meat of the post:
- To troubleshoot rules, you can use the rules engine to modify http response headers to indicate if a rule matches or not, as well as if the new CDN rule is being used.
- If trying to match the root of a domain, (e.g. www.scenic-shop.com/), you can use a `Request URL`condition w/ an `equals` or `ends with`, but the Request URL must end in a forward slash (`/`).
- If trying to match a url that ends in a directory name, you can use the `URL File Extension` conditional with a `Less Than` operator and a value of `1`.This would be used for rewriting `www.scenic-shop.com/blog/` to `www.scenic-shop.com/blog/page.html`.
- Those `URL Path` conditions with multiple values are evaluated as `OR` conditions, not `AND` conditions. 
- Find the sample rules in the Results section below.

## What was I trying to do?

- Criteria 1: Redirect all http protocols to https.

Azure doesn't offer a free SSL cert for apex domains (i.e. scenic-shop.com), but does offer free SSL certs for subdomains (e.g. www.scenic-shop.com, or calculators.scenic-shop.com). Since I don't feel like paying for a cert, I'm using subdomains for the site. However, since I want the site to be accessible at the apex domain, we have an additional requirement:

- Criteria 2: Redirect all requests to a subdomain (from scenic-shop.com to www.scenic-shop.com)

In order to preserve existing links to the site, the links need to stay the same. The blog's front page is currently hosted at `www.scenic-shop.com/blog/index.html` and I didn't want to move it to `www.scenic-shop.com/index.html` for tooling reasons. Therefore:

- Criteria 3: I needed to redirect all requests to www.scenic-shop.com/ to www.scenic-shop/blog/index.html.

Furthermore...

- Criteria 4: All requests to subdirectories should resolve to the index.html file in that directory. For example, www.scenic-shop.com/blog/ should resolve to www.scenic-shop.com/blog/index.html. (Luckily I eventually found that this a default behavior of the Azure CDN, so I didn't have to do anything special for this.)

## Initial Solution

My initial solution was to check the Microsoft documentation and write some rules. Nothing a little searching couldn't solve, right? Turns out the documentation for the Azure standard CDN is very sparse.  There are one or two examples of actual rules, and the descriptions of conditions and actions are very general. They describe what they are, and what the major portions are, but do not describe very well how they actually work. Likewise, searching out examples of rules on the internet proved frustrating. There were a few, but mostly just the same examples over and over.

So with the documentation in hand, I took a stab at writing four rules that would solve my problems. And after an indeterminate amount of time discovered that they didn't work. Unfortunately it was impossible to determine which rule was causing what behavior, and which one wasn't finding a match, or erroring out. As someone who utilizes unit tests when coding, I realized how dumb I was being. A few realizations hit me and we'll start keeping track of these here...

1. Write your rules one at a time and test them in isolation.
2. Keep a log of what rules you're editing, and the results of tests for that rule. (That way you can always go back).

Part of the frustration is that I kept finding inconsistent results in various browsers on various devices. Azure tells you that endpoint rules engine changes should take effect within 10 minutes. But the behavior I was seeing was all over the map; ten minutes, four hours, it didn't seem to matter. Oh wait, browsers keep caches right?  Another dumb mistake.

3. Clear your browser cache before testing. (Firefox has a shortcut that makes this quick work: refresh the page with `ctrl+shift+R` to reload and clear the cache for that page.)

After getting a few rules working, I geared up for the `/url/` => `/url/index.html` redirect rule. But before digging in:

4. Run the test without the rules in place to determine a baseline behavior.

Turns out I didn't need to write that rule.  It's already baked into Azure. I'm not sure if it's in the CDN, static website configuration, or what, but it works out of the box.

Finally, I was at the last rule, I needed to redirect `www.scenic-shop.com` to `www.scenic-shop.com/blog/index.html` but it just was not working. I didn't even know what was working or not.  Was the match condition not working? Was the action not working? Was the rule not being applied? I had no idea. I tried several variations on the rule but nothing worked consistently.

After a few days I realized a better way to test this. I'm sure modern web-api developer is rolling their eyes at how long this took me to figure out.  In my defense, I'm not a web developer.  I was reading up on HTTP standards and realized that you can modify response headers in the rules engine.  I could use this to indicate if a rule was being applied or not.  I could also use it to indicate if the rule was matching or not.  I could even use it to indicate if the rule was being applied at all.  This would be the mechanism I could use to troubleshoot the rules.

5. Use the rules engine to modify response headers to indicate if a rule is being applied, if it's matching, or if it's not matching.

6. There is probably a built-in method to do this with Azure CDN logs, but the header method was a simple way to do it that only took a few minutes to implement.

## The Test Setup

To setup this test, delete all existing rule engine rules for the CDN endpoint in question. (Remember to back them up or write them down first so you can recreate them.) 

7. Label your test criteria with a label for identification. E.g. Test A, Test B, etc.


8. Create a global rule that will append a http header to all responses with a custom header name and label identifying the test. E.g. `debug-control: B`, as shown below:

---

### Global Rule

- Action: Always Modify response header

{{<table "table table-striped table-bordered">}}
| Action | Header Name   | Value       |
| ------ | ------------- | ----------- |
| Append | debug-control | B |
{{</table>}}

---

9. Write a test rule with the action to append a http header indicating the success of the test, as shown below:

---
### Test Rule

- Condition: write as required...
- Action: Always Modify response header
{{<table "table table-striped table-bordered">}}
| Action | Header Name | Value       |
| ------ | ----------- | ----------- |
| Append | debug       | B found a match |
{{</table>}}

---

## Running the Tests

Load the website in a browser, open the developer tools and show the site HTTP headers. Refresh the page with a clean cache, and now you have a way to:
- Identify if the CDN rules engine is running the latest version of the test (`debug-control: B` will be listed in the response headers), and
- identify if the test rule's condition succeeded with a match (`debug: B found a match` will be listed in the response headers).

If the `debug-control` header does not match your current test, you know the rules engine is not running the latest version of your rules. Wait a few minutes and refresh again. One the `debug-control` header matches your current test, the presence of the `debug:` header indicates if a match was found.

## Results

These are the rules that I'm currently using:

### Rule: EnforcedHTTPSv2
- Purpose: Redirect HTTP to HTTPS
- Condition: Request Protocol
{{<table "table table-striped table-bordered">}}
| Operator | Value | 
| -------- | ----- |
| Equals   | HTTP  |
{{</table>}}

- Action: Url Redirect
{{<table "table table-striped table-bordered">}}
| Type | Protocol | Host                | Path | Query | Fragment |
| ---- | -------- | ------------------- | ---- | ----- | -------- |
| 302  | HTTPS    |  |      |       |          |
{{</table>}}

### Rule: ApexRedirect
- Purpose: Redirect scenic-shop.com/ to www.scenic-shop.com

- Condition: URL Path
{{<table "table table-striped table-bordered">}}
| Operator  |                                              | Case |
| --------- | -------------------------------------------- | ---- |
| Starts With | http://scenic-shop.com/, https://scenic-shop.com/index.html | none |
{{</table>}}

- Action: Url Redirect
{{<table "table table-striped table-bordered">}}
| Type | Protocol | Host                | Path | Query | Fragment |
| ---- | -------- | ------------------- | ---- | ----- | -------- |
| 302  | HTTPS    | www.scenic-shop.com |      |       |          |
{{</table>}}

### Rule: blogIndexRewritev5
- Purpose: Redirect www.scenic-shop.com/ to www.scenic-shop.com/blog/index.html

- Condition: URL Path
{{<table "table table-striped table-bordered">}}
| Operator  |                                              | Case |
| --------- | -------------------------------------------- | ---- |
| Ends With | scenic-shop.com/, scenic-shop.com/index.html | none |
{{</table>}}

- Action: Url Rewrite
{{<table "table table-striped table-bordered">}}
| Pattern | Destination      | Preserve unmatched path |
| ------- | ---------------- | ----------------------- |
| /       | /blog/index.html | no                      |
{{</table>}}

Notes:
 - URL Paths MUST end in a forward slash (`/`) or the to be matched to a directory without a file extension.  (E.g. `scenic-shop.com/`, but `scenic-shop.com` will not.)
 - Those `URL Path` conditions with multiple values are evaluated as `OR` conditions, not `AND` conditions, just as we suspected.
- URL Rewrite will replace the `pattern` with the `destination`.
- Request URL: `https://www.scenic-shop.com/testing/stuff.html`
- Protocol: `https`
- Host: `www.scenic-shop.com`
- URL Path: `/testing/stuff.html`
- URL File: `stuff.html`
- URL File Extension: `html`

### Conclusion

Since figuring out this workaround for testing the rules engine, it only took me a half an hour or so to get the rules working as I'd hoped.  I know there have to be better ways to do this, even to automate it if you want to, but the above manual method sufficed for my needs. A few possibilities come to mind (again, I'm not a web-api dev, I'm sure there are a lot more):
- Use something like postman or insomnia to test the rules engine header codes.
- Create a cli script to run a repeatable set of request URLs and inspect the http response headers. You could even probably use the cli to set the rules as well.
- Inspect Azure CDN logs for rules engine results.