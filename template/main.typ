// #import "@local/unvirennes-slides:0.2.0": unirennes-slides, title-slide, slide, slide-full, unirennes-colors, note
#import "../src/lib.typ": unirennes-slides, title-slide, slide, slide-full, unirennes-colors, note

#show: unirennes-slides.with(
  short-authors: [Augustin Godinot],
  title: text(size: 56pt, [Manipulation-proof \ auditing]),
  subtitle: [Some practical relaxations of black-box auditing],
  info: box(
    width: 24em,
    baseline: 25%,
    h(1fr) + [TechTalk PEReN] + h(1fr) + sym.dot.c + h(1fr) + [November 12th 2024] + h(1fr),
  ),
  logo: image("assets/logos/univ-rennes-blanc.png"),
  logos: (
    image("assets/logos/univ-rennes.png"),
    // Add you own logos here
  ),
  people: (
    "Augustin Godinot": [
      // add the person's picture here
    ],
  ),
  // notes: "page",
)

#title-slide[]

= This is is the section title

#slide(title: [TODO], subtitle: [Automatically put the header(level:2) here?])[

  == This is the slide title

  The section title is not included in the slide unless it is asked for.
]


= This is an other section

#slide(title: [Something])[
  == This is something else
]
