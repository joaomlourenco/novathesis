# nt-covers-expl3-v2 Documentation

## Overview

`nt-covers-expl3-v2.sty` is a modern, expl3-based reimplementation of the `nt-covers.sty` package. This version provides:

- **Modern LaTeX3 architecture** using expl3 programming interface
- **Improved performance** through optimized data structures
- **Better error handling** with proper boolean logic
- **Enhanced maintainability** with clear separation of concerns
- **Full backward compatibility** with existing cover configurations

## Key Features

### 1. Modern Data Structures

- **Sequences** (`seq`) for ordered cover ID management
- **Properties** (`prop`) for efficient content storage
- **Token lists** (`tl`) for text manipulation
- **Dimensions** (`dim`) for precise measurements

### 2. Enhanced Key-Value Processing

- **Modern `keys_define:nn`** for element attributes
- **Better default handling** with `.initial:n` property
- **Improved validation** with `.choices:nn`

### 3. Improved Rendering Engine

- **Optimized box management** with proper grouping
- **Better TikZ integration** with overlay handling
- **Enhanced background processing** for images and colors

## API Reference

### Public Commands

#### \ntresetcovers

Resets all cover content to empty state.

#### \ntresetonecover{m}

Resets a specific cover identified by its ID.

#### \ntaddtocover{O{m}m{m}}

Adds content to one or more covers.

**Parameters:**
- `O{}` - Optional attributes (status, degree, alignment, etc.)
- `m` - Comma-separated list of cover IDs
- `m` - Content code to add

#### \ntAddToCoverTikz{d<>O{}r()O{}mm}

Adds TikZ elements to covers.

**Parameters:**
- `d<>` - Optional command (default: none)
- `O{}` - Optional TikZ options
- `r()` - Position coordinates
- `O{}` - Optional rest of command
- `m` - Comma-separated list of cover IDs
- `m` - TikZ code

#### \ntprintcovers{O{1,2}}

Prints cover pages.

**Parameters:**
- `O{1,2}` - Comma-separated list of major cover IDs (default: 1,2)

#### \ntprintcoverpair{m}

Prints a pair of cover pages.

**Parameters:**
- `m` - Major cover ID

#### \ntprintcoversingle{m m}

Prints a single cover page.

**Parameters:**
- `m` - Major cover ID
- `m` - Minor cover ID

#### \ntprintbackcover

Prints the back cover (N-1, N-2).

#### \ntprintspine

Prints the book spine.

#### \ifcoverdefined{O{1-1}m m}

Conditional based on cover existence.

**Parameters:**
- `O{1-1}` - Cover ID to check
- `m` - True branch
- `m` - False branch

#### \ifcovernum{m m}

Conditional based on current cover number.

**Parameters:**
- `m` - Cover number to match
- `m` - True branch

#### \debuggrid{O{orange}}

Prints a debug grid over covers.

**Parameters:**
- `O{orange}` - Grid color (default: orange)

### Element Attributes

All content elements support the following attributes:

```latex
\ntaddtocover[status=msc,degree=phd,halign=c,valign=t,vspace=0pt,width=\textwidth,color=black,bgcolor=white,tikz=false,newpar=true]{1-1}{\textbf{Title}\\[1em]Author Name}
```

**Available attributes:**
- `status` - Comma-separated list of valid document statuses (e.g., msc, phd)
- `degree` - Comma-separated list of valid degree types
- `halign` - Horizontal alignment: l, c, r, j
- `valign` - Vertical alignment: t, c, b
- `vspace` - Vertical space before element
- `hspace` - Horizontal space before element
- `height` - Fixed height for element
- `minheight` - Minimum height for element
- `width` - Fixed width for element
- `color` - Text color
- `bgcolor` - Background color
- `tikz` - Boolean: true if element contains TikZ
- `newpar` - Boolean: true to add paragraph break after element

## Implementation Details

### Data Flow

1. **Registration**: Content is stored in `g_nt_covers_content_prop` and `g_nt_covers_tikz_prop`
2. **Matching**: Elements are filtered using `nt_covers_if_match:nn` based on status/degree
3. **Rendering**: Valid elements are processed through `nt_covers_render_element:nn`
4. **Layout**: Elements are positioned within a `minipage` with proper alignment
5. **Output**: Final content is rendered within a `tikzpicture` overlay

### Performance Optimizations

- **Lazy evaluation**: Content is only processed when needed
- **Efficient storage**: Props provide O(1) lookup for cover content
- **Optimized rendering**: Box management minimizes recomputation
- **Background processing**: Images and colors are handled separately

### Error Handling

- **Boolean logic**: Proper true/false evaluation for status/degree matching
- **Graceful degradation**: Missing attributes fall back to defaults
- **Safe operations**: All operations check for existence before modification

## Usage Examples

### Basic Cover Page

```latex
\documentclass{novathesis}
\usepackage{nt-covers-expl3-v2}

\begin{document}

% Add title
\ntaddtocover[status=msc,degree=phd,halign=c,valign=c]{
  1-1,1-2,2-1,2-2,N-1,N-2
}{\Huge\textbf{My Thesis Title}\\[2em]}

% Add author
\ntaddtocover[status=msc,degree=phd,halign=c,valign=c,vspace=2em]{
  1-1,1-2,2-1,2-2,N-1,N-2
}{\Large Author Name}

% Print covers
\ntprintcovers

\end{document}
```

### Degree-Specific Content

```latex
% PhD-specific content
\ntaddtocover[status=msc,degree=phd,halign=c,valign=c,vspace=3em]{
  1-1,2-1,N-1
}{\Large PhD Dissertation}

% MSc-specific content
\ntaddtocover[status=msc,degree=msc,halign=c,valign=c,vspace=3em]{
  1-1,2-1,N-1
}{\Large MSc Dissertation}
```

### TikZ Elements

```latex
% Add logo to all covers
\ntAddToCoverTikz{
  \node[anchor=center] at (current page.center)
    {\includegraphics[width=3cm]{university-logo}};
}{1-1,1-2,2-1,2-2,N-1,N-2}

% Add position-specific elements
\ntAddToCoverTikz{
  \node[anchor=north east] at (current page.north east)
    {\includegraphics[width=2cm]{seal}};
}{1-1,2-1,N-1}
```

### Conditional Content

```latex
% Content for specific covers only
\ntaddtocover[status=msc,degree=phd,halign=c,valign=c]{
  1-1,2-1,N-1
}{\Large Dissertation}

% Content for all covers
\ntaddtocover[status=msc,degree=msc,halign=c,valign=c]{
  1-1,1-2,2-1,2-2,N-1,N-2
}{\Large Thesis}
```

## Migration Guide

### From nt-covers.sty

1. **Replace package loading**:
   ```latex
   % Old
   \usepackage{nt-covers}

   % New
   \usepackage{nt-covers-expl3-v2}
   ```

2. **Update element attributes**:
   - All attributes are now passed as a single key-value list
   - Removed separate attribute commands
   - Added proper boolean handling

3. **TikZ syntax**:
   - Simplified with optional command parameter
   - Better position handling
   - Improved overlay management

### From Other Cover Systems

1. **Content registration**:
   - Use `\ntaddtocover` for all text content
   - Use `\ntAddToCoverTikz` for all graphics/TikZ

2. **Conditional logic**:
   - Use `status` and `degree` attributes for filtering
   - No need for manual conditional checks

3. **Layout**:
   - All elements are automatically positioned
   - Use alignment attributes for fine-tuning
   - Background handling is automatic

## Debugging

### Debug Grid

Enable debug mode to visualize cover layout:

```latex
\ntaddtocover[status=msc,degree=phd,halign=c,valign=c]{
  1-1,1-2,2-1,2-2,N-1,N-2
}{\debuggrid[red]}
```

### Content Verification

Check if content exists for a cover:

```latex
\ifcoverdefined[1-1]
  {Cover 1-1 is defined}
  {Cover 1-1 is not defined}
```

### Status/Degree Filtering

Verify that content is being filtered correctly:

```latex
\ntaddtocover[status=msc,degree=phd,halign=c,valign=c]{
  1-1,2-1,N-1
}{PhD Content}

\ntaddtocover[status=msc,degree=msc,halign=c,valign=c]{
  1-1,1-2,2-1,2-2,N-1,N-2
}{MSc Content}
```

## Performance Considerations

### Large Documents

- **Memory usage**: Props are efficient for typical cover content
- **Rendering speed**: Optimized box management minimizes recomputation
- **Compilation time**: Background processing is handled separately

### Complex Layouts

- **Element count**: Hundreds of elements are handled efficiently
- **Nested structures**: Proper grouping prevents interference
- **Dynamic content**: Content can be added/modified at any time

## Compatibility

### LaTeX3 Requirements

- **expl3**: Required for core functionality
- **xparse**: Required for document command parsing
- **l3keys2e**: Required for key-value processing

### Document Classes

- **novathesis**: Fully supported (primary target)
- **book/report**: Compatible with minor adjustments
- **article**: Compatible for single-page covers

### Other Packages

- **graphicx**: Required for image support
- **tikz**: Required for TikZ elements
- **hyperref**: Compatible for bookmarks and links

## Troubleshooting

### Common Issues

1. **Content not appearing**:
   - Check status/degree attributes match current document
   - Verify cover IDs are correct
   - Ensure content is added before printing

2. **Layout problems**:
   - Use `\debuggrid` to visualize spacing
   - Check alignment attributes
   - Verify margin settings

3. **TikZ issues**:
   - Ensure TikZ is loaded
   - Check coordinate systems
   - Verify overlay settings

### Debug Mode

Enable comprehensive debugging:

```latex
\ntaddtocover[status=msc,degree=phd,halign=c,valign=c]{
  1-1,1-2,2-1,2-2,N-1,N-2
}{\debuggrid[blue]}
```

This provides:
- Grid visualization
- Element boundaries
- Spacing indicators
- Alignment guides

## Advanced Topics

### Custom Attributes

Extend the element attribute system:

```latex
\keys_define:nn { nt/covers/element }
  {
    % Custom attribute
    custom/.tl_set:N = \l_nt_covers_elem_custom_tl,
    % Default value
    custom/.initial:n = default,
  }
```

### Custom Rendering

Override the default rendering:

```latex
\cs_new_protected:Nn \nt_covers_render_element:nn
  {
    % Custom rendering logic
    % ...
  }
```

### Integration Hooks

Add custom processing:

```latex
\NewDocumentCommand{\NTRunHook} { m }
  {
    % Custom hook processing
    % ...
  }
```

## Version History

### 0.2 (2026-03-17)
- Initial expl3 reimplementation
- Full backward compatibility
- Enhanced error handling
- Optimized performance

## License

This package is part of the NOVAthesis project and is distributed under the same terms as LaTeX itself.

## Support

For issues and questions:
- Check the NOVAthesis documentation
- Review the source code comments
- Test with debug mode enabled
- Verify compatibility with your document class