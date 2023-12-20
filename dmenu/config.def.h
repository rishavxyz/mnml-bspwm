/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const int user_bh = 0;               /* add an defined amount of pixels to the bar height */

static const char *fonts[] = {
	"sans:size=10:weight=medium"
};
static const char *prompt = ">_";      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
	[SchemeNorm] = { "#c4a7e7", "#191724" },
	[SchemeSel] = { "#191724", "#eb6f92" },
	[SchemeOut] = { "#f6c177", "#191724" },
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
