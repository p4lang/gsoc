# P4 Formatter
**Contributor**: Nitish Kumar ([@snapdgn])

**Mentors**: Bili Dong ([@qobilidop]), Fabian Ruffy ([@fruffy])

[@snapdgn]: https://github.com/snapdgn
[@qobilidop]: https://github.com/qobilidop
[@fruffy]: https://github.com/fruffy

## Table of Contents
- [P4 Formatter](#p4-formatter)
   * [Table of Contents](#table-of-contents)
   * [Abstract](#abstract)
   * [Goals](#goals)
   * [Results](#results)
   * [Implementation details](#implementation-details)
      + [New p4fmt backend](#new-p4fmt-backend)
      + [Pretty-Printer for `p4fmt`](#pretty-printer-for-p4fmt)
      + [Reference checker for `p4fmt`](#reference-checker-for-p4fmt)
   * [Limitations](#limitations)
   * [Future Work](#future-work)

## Abstract
This project aims to develop a code formatter for P4. While the reference P4 compiler (P4C) provides foundational components, such as an AST/IR parser and a pretty printer, key gaps remain.
The current AST/IR does not retain comments from the original source code, and the pretty printer lacks the flexibility required for common formatting options.
This project addresses these issues by enhancing the AST/IR to preserve comments and adapting the pretty printer to support customizable formatting rules, ultimately creating a functional P4 code formatter for the first time.

## Goals
- Modify the AST to attach comments from the original source code.
- Update the pretty printer to print the newly attached comments.
- Implement common formatting options to enhance the code formatting capabilities.

## Results
The project has successfully integrated comment preservation and this has been leveraged to improve the pretty printer, enabling it to print the newly attached comments.

## Implementation details

### New p4fmt backend
Relevant PRs:
- https://github.com/p4lang/p4c/pull/4710
- https://github.com/p4lang/p4c/pull/4845
- https://github.com/p4lang/p4c/pull/4795
- https://github.com/p4lang/p4c/pull/4718

Build & Usage Instructions: https://github.com/p4lang/p4c/tree/main/backends/p4fmt

The primary task in creating the P4Fmt backend was the attachment of comments to IR nodes, ensuring the preservation of comments during code formatting. We drew inspiration from how Bazel tools [preserve comments](https://jayconrod.com/posts/129/preserving-comments-when-parsing-and-formatting-code), and adapted the strategy to fit the P4 language's specific requirements.

The lexer collects all comments along with their position information into a global list managed by the `InputSources` class. Each AST node embeds a `Comments` struct to store relevant comments, which are categorized into two types:

- Prefix Comments: Comments that appear before a node.
- Suffix Comments: Inline comments that trail after a node.

Attachment is done in two AST passes:
- _Pre-order Pass_: During this traversal, we attach comments preceding a node (i.e., prefix comments) to the AST node immediately after the comment.
- _Post-order Pass_: For inline trailing comments (suffix comments), we attach them to the AST node right before the comment.

**Optimizing Comment Management**:

Initially, we embedded comments directly within each AST node, using two vectors (prefix and suffix) to store them. However, this approach could have introduced overhead for every node, potentially slowing down compilation and increasing memory consumption. To address this, we moved the comments into a local side map (<node-id, comments>), associating unique node IDs (clone_id) with their comments. This map allowed us to efficiently attach comments during the second traversal, reducing both memory usage and performance impact.

### Pretty-Printer for `p4fmt`
Relevant PRs:
- https://github.com/p4lang/p4c/pull/4862
- https://github.com/p4lang/p4c/pull/4795
- https://github.com/p4lang/p4c/pull/4887

We modified the existing pretty-printer, `top4` , to handle the newly attached comments in the P4Fmt backend. This update ensures that both prefix and suffix comments, now stored and attached to IR nodes via the side map, are correctly formatted and printed alongside the relevant P4 constructs.

### Reference checker for `p4fmt`

Relevant PR: https://github.com/p4lang/p4c/pull/4778

Build & Usage Instructions: https://github.com/p4lang/p4c/tree/main/backends/p4fmt

We also implemented a reference checker for the P4Fmt formatter, using golden tests to validate the formatted output against expected results. It processes an input P4 file, formats it with P4Fmt, and then compares the result to a reference file using `diff`.

Key Features:

- Formats the input P4 file and compares it to the provided reference file.
- The `--overwrite` option or the `P4FMT_REPLACE` environment variable allows updating the reference file with the new formatted output instead of comparing.

## Limitations
- Free floating comments are not handled currently and remain unassociated with any nodes.
   ```
   // struct comment
   struct headers {
      ...
   }

   // free floating comments

   // control block comments
   control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
   ...
   }
   ```
- Code constructs with multiple potential points for comment attachment are not supported.
   ```
   const /* (1) */ bit<16> /* (2) */  TYPE_IPV4 /* (3) */ = /* (4) */ 0x800 /* (5) */;
   ```
- The formatter currently does not preserve comments through IR transformations that occur during compilation. For now, it is designed to handle comment printing immediately after parsing and before any transformations are applied.

## Future Work
- Better algorithm for comment attachment.</br>
   > We need a robust set of heuristics for this, as comment association is the most challenging aspect to get right.</br> For more discussion on the topic, see: </br>
      - https://github.com/golang/go/issues/20744. </br>
      - https://github.com/dave/dst. </br>
      - https://go-review.googlesource.com/c/go/+/429639.
- Support for formatting options(line wrapping, indentation etc.).
- Customization of formatting styles via configuration files & cmd-line options.
