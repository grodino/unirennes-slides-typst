#import "@preview/polylux:0.3.1": polylux-slide, logic, utils
#import "../common/src/colors.typ": *
#import "../common/src/colors.typ" as unirennes-colors

////////////////////////////////////////////////////////////////////////////////
// GLOBAL THEME INFO                                                          //
////////////////////////////////////////////////////////////////////////////////
#let file-meta = state("file-meta")
#let is-appendix = state("is-appendix", false)
#let PRESENTATION-16-9 = (width: 841.89pt, height: 473.56pt)

////////////////////////////////////////////////////////////////////////////////
// TITLE SLIDE                                                                //
////////////////////////////////////////////////////////////////////////////////
#let title-slide(body) = polylux-slide(
  locate(loc => {
    // Displays the title slide. Takes information passed to the theme when it
    // was initialized
    // Get the slides metadata
    if file-meta == none {
      return "State was not initialized"
    }
    let meta = file-meta.at(loc)

    set text(font: "UniRennes")

    hide(body)

    // Main title + logos
    block(
      width: PRESENTATION-16-9.width,
      height: if meta.people != none {
        60%
      } else {
        100%
      },
      // height: 60%,
      outset: 0em,
      inset: 0em,
      breakable: false,
      stroke: none,
      spacing: 0em,
      stack(
        dir: ltr,
        if meta.logos != none {
          block(
            width: 37%,
            inset: 1em,
            columns(
              2,
              for logo in meta.logos {
                logo
              },
            ),
          )
        },
        align(
          center + horizon,
          text(size: 1.7em, fill: primary.dark)[
            #text(
              font: "UniRennes Inline",
              fill: accent-blue.light.darken(50%),
              meta.title,
            )\
            #text(size: 22pt, style: "oblique", font: "Newsreader", meta.subtitle)

            #text(size: .4em, weight: "regular")[
              #meta.info
            ]
          ],
        ),
      ),
    )

    // People
    if meta.people != none {
      set image(width: 2 * 2.4cm)
      block(
        width: PRESENTATION-16-9.width,
        height: 40%,
        outset: 0em,
        inset: (x: .5em),
        breakable: false,
        stroke: none,
        spacing: 0em,
        fill: accent-blue.light.darken(50%),
        align(
          center + horizon,
          for person in meta.people {
            box(width: 100% / meta.people.len())[
              #person.last()
              #place(
                top + center,
                circle(radius: 2.4cm, stroke: 6pt + accent-blue.light.darken(50%)),
              )

              #v(-15pt)
              #text(size: 20pt, fill: primary.light, person.first())
            ]
          },
        ),
      )

      // The little seeparator between people and the title
      place(
        left + horizon,
        dx: PRESENTATION-16-9.width / 2 - 6em / 2,
        dy: 10%,
        rect(width: 6em, height: .5em, radius: .25em, fill: accent-pink.light),
      )
    }
  }),
)

////////////////////////////////////////////////////////////////////////////////
// UTILS                                                                      //
////////////////////////////////////////////////////////////////////////////////

// Displays the title and relevant information in the left banner
#let displayed-title(title, subtitle: none, vignette: none, appendix: false) = locate(loc => {
  let meta = file-meta.at(loc)
  set align(bottom)

  block(
    width: 100%,
    height: 100% - 3cm,
    inset: 1em,
    clip: true,
  )[
    //////////////////////////////////////////////////////////////////////////
    // Slide title
    #set align(top)
    #text(font: "UniRennes", fill: primary.light, heading(level: 2, title))

    //////////////////////////////////////////////////////////////////////////
    // Slide subtitle
    #if subtitle != none {
      v(1em)
      text(
        fill: primary.light,
        weight: "light",
        style: "italic",
        size: 24pt,
        font: "Newsreader",
        subtitle,
      )
    }

    //////////////////////////////////////////////////////////////////////////
    // Slide vignette
    #if vignette != none {
      set text(fill: primary.light, font: "Newsreader")
      vignette
    }

    //////////////////////////////////////////////////////////////////////////
    // Slide TOC
    #set align(bottom)

    // Get the current section name
    #let sections = utils.sections-state.at(loc)
    #let current-section = none

    // Display the toc only when the first chapter has begun
    #if sections.len() > 0 {
      current-section = sections.last().body

      for item in query(heading.where(level: 1, outlined: true), loc) {
        if item.body == [Appendix] {
          continue
        }

        if item.body != current-section {
          text(fill: primary.light, font: "UniRennes", size: 16pt, item.body)
        } else {
          text(
            fill: primary.light,
            size: 16pt,
            font: "UniRennes",
            weight: "bold",
            item.body,
          )
        }
        linebreak()
      }
    }
  ]

  block(
    width: 100%,
    inset: 10pt,
    {
      if meta.logo != none {
        set align(left + bottom)
        set text(size: 12pt, fill: primary.light)

        let size = 2em

        stack(
          dir: ltr,
          {
            set image(width: size, height: size)
            meta.logo
          },
          box(height: size, width: 100% - size)[
            #set align(right + horizon)

            #if appendix == false {
              logic.logical-slide.display() + "/"
              numbering("1", logic.logical-slide.final(loc).first())
            } else {
              "Appx. " + logic.logical-appendix.display("1") + "/"
              numbering("1", logic.logical-appendix.final(loc).first())
            } \
            //
            #meta.short-authors
          ],
        )
      }
    },
  )
})

////////////////////////////////////////////////////////////////////////////////
// SLIDES DECLARATIONS                                                        //
////////////////////////////////////////////////////////////////////////////////
#let slide(title: none, subtitle: none, vignette: none, appendix: false, body) = locate(loc => {
  let meta = file-meta.at(loc)

  polylux-slide(
    // appendix: appendix,
    {
      box(
        width: meta.split-size * PRESENTATION-16-9.width,
        height: 100%,
        outset: 0em,
        baseline: 0em,
        stroke: none,
        fill: accent-blue.light.darken(50%),
        displayed-title(title, subtitle: subtitle, vignette: vignette, appendix: appendix),
      )
      box(
        width: (100% - meta.split-size) * PRESENTATION-16-9.width,
        height: 100%,
        outset: 0em,
        inset: 1em,
        baseline: 0em,
        stroke: none,
        fill: primary.light,
      )[
        #set align(left + horizon)
        #set text(fill: primary.dark)
        #body
      ]
    },
  )
})

#let slide-full(body, appendix: false, fill: white) = polylux-slide(
  // appendix: appendix,
  box(inset: 1em, width: PRESENTATION-16-9.width, height: 100%, fill: fill)[
    #set align(center + horizon)
    #set text(fill: primary.dark)
    #body
  ],
)

////////////////////////////////////////////////////////////////////////////////
// NOTES                                                                      //
////////////////////////////////////////////////////////////////////////////////
#let note(body) = locate(loc => {
  // Ignore notes that come from duplicated slides
  if logic.subslide.at(loc).first() <= 1 [
    #metadata((page: logic.logical-slide.at(loc).first(), body: body)) <note>
  ]
})

#let notes-page() = locate(loc => page(paper: "a4", margin: 1em)[
  #let notes = query(<note>, loc)
  #set text(size: 12pt)

  #for note in notes {
    text(size: 16pt, weight: "bold", [Slide #note.value.page])
    linebreak()
    note.value.body
    parbreak()
  }
])

////////////////////////////////////////////////////////////////////////////////
// THEME DECLARATION                                                          //
////////////////////////////////////////////////////////////////////////////////
#let unirennes-slides(
  short-authors: [],
  title: [],
  subtitle: [],
  info: [],
  logo: none,
  logos: none,
  people: none,
  split-size: 25%,
  notes: "hide",
  body,
) = {
  // Set the page dimensions (depends on whether the notes are displayed)
  let page-width = PRESENTATION-16-9.width
  if "side" in notes {
    page-width = 2 * PRESENTATION-16-9.width
  }
  set page(paper: "presentation-16-9", width: page-width, margin: 0pt)

  // Set the outline entry properties when displayed as main content
  show outline.entry: it => {
    it.body
  }

  // emph with a different color
  show emph: set text(fill: accent-orange.light)

  // Headings :
  //  - level 1 is never displayed (only in TOC). Used from structure
  //  - level 2 is used for slides titles
  //  - level 3- is used inside the slides

  // Hide level 1 headings but keep them in the TOC
  show heading.where(level: 1): it => utils.register-section(it.body)

  // Heading font properties
  show heading.where(level: 2): set text(font: "UniRennes", size: 28pt)

  // Regular text properties
  set text(font: "Newsreader", weight: "light", size: 22pt)

  // Change the marker for lists
  set list(marker: (sym.triangle.filled.r, $=>$))

  // Change the font of the labeled lists
  show terms.item: it => [
    #set par(hanging-indent: terms.hanging-indent)

    #text(font: "UniRennes", weight: "bold", it.term)
    #terms.separator
    #it.description\
  ]

  // Save all the theme information in a state container
  file-meta.update((
    short-authors: short-authors,
    title: title,
    subtitle: subtitle,
    info: info,
    logo: logo,
    logos: logos,
    people: people,
    split-size: split-size,
    notes: notes,
  ))

  body

  // Display all the notes in a4 pages
  if "page" in notes {
    notes-page()
  }
}
