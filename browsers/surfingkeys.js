api.Hints.setCharacters("asdfghjkl"); // Middle row.
settings.hintAlign = "left";

api.map("<Ctrl-[>", "<Esc>"); // Alias for esc.

// Scrolling.
api.map("<Ctrl-f>", "d"); // Scroll half page down.
api.map("<Ctrl-b>", "e"); // Scroll half page up.
api.map("s", ";fs"); // Pick a scrollable area to focus.

// Tabs.
api.map("d", "x"); // Close current tab.
api.map("u", "X"); // Restore tab.
api.map("t", "T"); // Choose tab.
// zi, zo, zr -- Zoom in/out/reset.

// Other.
api.map("F", "gf"); // Open link in new tab without focusing it.

// History.
api.map("<Ctrl-o>", "S"); // Go back in history.
api.map("<Ctrl-i>", "D"); // Go forward in history.
