# Campus Events

Flutter I, Lab 1 ("Your App"). Domain: **campus events** - browse, search and
filter events, register for them, create and edit your own, switch theme.

## Screenshots

Added three screenshots:

- light theme
- dark theme
- tablet 

## Decisions

The list of events and the profile live in the State of the shell, so every tab
reads the same data and changes it only through callbacks. The theme mode lives
in MyApp above MaterialApp, because the theme must be rebuilt for the whole app.
I used one Navigator with named routes: the shell is in `routes:`, while detail
and form are built in onGenerateRoute from typed argument classes. The form
returns the new Event through pop, and the caller checks null and mounted before
setState. The list switches to a grid with LayoutBuilder, because it needs the
width the parent gives, not the width of the screen. Colours come only from
ColorScheme and text sizes only from textTheme, so dark mode works by itself.
