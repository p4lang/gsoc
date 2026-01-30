# The Blog 
Welcome to the "engine room" of the site. This directory contains all the theme-related logic and configurations.

### Where are the posts?
You’ll notice there is no `_posts` directory here. That’s intentional! To keep our project root clean, we store our writing in the yearly folders (like `/2024`, `/2025`, and `/2026`) at the very top of the repository.

When the **CI/CD pipeline** runs, it automatically:
1.  Creates a temporary `blog/_posts` folder.
2.  Copies all your yearly folders into it.
3.  Builds the site from this combined structure.

---

### The Golden Rules for Writing
Since we are using the **Chirpy** theme, it is very strict about how files are named and formatted. If these aren't followed, your post might not show up at all.

#### 1. File Naming
All files must include the date in the filename to be recognized by Jekyll.
* **Correct Format:** `YYYY-MM-DD-filename.md`
* **Example:** `2024-05-27-ideas_list.md`

#### 2. The Required Header (Front Matter)
Every single post needs a block at the very top. Here is a standard template:

```yaml
---
title: P4 GSoC 2024 Ideas List
date: 2024-05-27 10:10:10 +/-TTTT
categories: [GSOC 2024, Contributor Guideline 2024]
tags: [gsoc2024]             # Keep tags lowercase!
render_with_liquid: false
permalink: /posts/2024/idea_list/
---
```