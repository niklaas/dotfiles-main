import {
  ArrowKeyCode,
  ControlOrSymbolKeyCode,
  ifApp,
  LayerKeyParam,
  LetterKeyCode,
  map,
  NumberKeyCode,
  rule,
  simlayer,
  StickyModifierKeyCode,
  ToKeyParam,
  withCondition,
  withMapper,
  writeToProfile,
} from "https://deno.land/x/karabinerts@1.27.0/deno.ts";

const alphaNumericKeys = (
  "1234567890" +
  "qwertyuiop" +
  "asdfghjkl" +
  "zxcvbnm"
).split("") as (LetterKeyCode | NumberKeyCode)[];
const symbols = [
  "grave_accent_and_tilde",
  ...["hyphen", "equal_sign"],
  ...["open_bracket", "close_bracket", "backslash"],
  ...["semicolon", "quote"],
  ...["comma", "period", "slash"],
] as ControlOrSymbolKeyCode[];
const otherKeys = [
  "tab",
  "delete_or_backspace",
  "return_or_enter",
  "left_arrow",
  "right_arrow",
  "up_arrow",
  "down_arrow",
  "spacebar",
] as (ArrowKeyCode | ControlOrSymbolKeyCode)[];
const leftHomeRow = "asdf".split("") as LetterKeyCode[];
const rightHomeRow = [..."jkl".split(""), "semicolon"] as (
  | LetterKeyCode
  | ControlOrSymbolKeyCode
)[];

/**
 * sequence: control < option < command < shift
 */
const homeRowSimLayer = (
  from_key: LayerKeyParam,
  to_modifier: StickyModifierKeyCode,
  homeRowKeys: (LayerKeyParam | ToKeyParam)[],
) =>
  simlayer(from_key, `${from_key}-${to_modifier}-mode`).manipulators([
    withMapper(
      [...alphaNumericKeys, ...symbols, ...otherKeys].filter(
        (key) => !homeRowKeys.includes(key),
      ),
    )((key) =>
      map(key, "optionalAny").to({ key_code: key, modifiers: [to_modifier] }),
    ),
  ]);

writeToProfile("Default", [
  rule("caps-lock to left-control, escape if alone").manipulators([
    map("caps_lock", "optionalAny").to("left_control").toIfAlone("escape"),
  ]),
  rule("enter to right-control, enter if alone").manipulators([
    map("return_or_enter", "optionalAny")
      .to("right_control")
      .toIfAlone("return_or_enter"),
  ]),
  rule("escape to hyper").manipulators([map("escape").toHyper()]),
  homeRowSimLayer("f", "left_shift", leftHomeRow),
  homeRowSimLayer("d", "left_command", leftHomeRow),
  homeRowSimLayer("s", "left_option", leftHomeRow),
  homeRowSimLayer("a", "left_control", leftHomeRow),
  homeRowSimLayer("j", "right_shift", rightHomeRow),
  homeRowSimLayer("k", "right_command", rightHomeRow),
  homeRowSimLayer("l", "right_option", rightHomeRow),
  homeRowSimLayer("semicolon", "right_control", rightHomeRow),
  simlayer("spacebar", "space-mode (code)").manipulators([
    // left side: brackets,
    map("s").to("open_bracket"), // [
    map("x").to("close_bracket"), // ]
    map("f").to("9", "left_shift"), // (
    map("v").to("0", "right_shift"), // )
    map("d").to("open_bracket", "left_shift"), // {
    map("c").to("close_bracket", "left_shift"), // }
    // right side: navigation
    map("y").to("left_arrow", ["left_shift", "option"]),
    map("u").to("return_or_enter", "left_command"), // command + enter
    map("i").to("return_or_enter"), // enter
    map("o").to("right_arrow", ["left_shift", "option"]),
    map("h").to("left_arrow"), // vim left
    map("j").to("down_arrow"), // vim down
    map("k").to("up_arrow"), // vim up
    map("l").to("right_arrow"), // vim right
    // symbols
    map("t").to("grave_accent_and_tilde", "right_shift"), // ~ (t)ilde
    map("g").to("grave_accent_and_tilde"), // ` (g)rave
    map("r").to("hyphen", "left_shift"), // _ run(t)er
    map("q").to("hyphen"), // -
    map("w").to("backslash", "left_shift"), // | wall
    map("e").to("equal_sign"), // = (e)qual
    map("a").to(1, "right_shift"), // ! aaahhhh!
  ]),
  simlayer("i", "i-mode (text manipulation and selection)").manipulators([
    map("w").to("delete_or_backspace", "left_option"), // undo word
    map("e").to("delete_or_backspace"), // undo
    map("r").to("delete_forward"), // delete forward
    map("s").to("left_arrow", "option"),
    map("d").to("up_arrow", "option"),
    map("f").to("down_arrow", "option"),
    map("g").to("right_arrow", "option"),
    map("x").to("left_arrow", "command"),
    map("c").to("up_arrow", "command"),
    map("v").to("down_arrow", "command"),
    map("b").to("right_arrow", "command"),
  ]),
  simlayer("z", "z-mode").manipulators([
    map("comma").to({ key_code: "left_arrow", modifiers: ["left_control"] }),
    map("period").to({ key_code: "right_arrow", modifiers: ["left_control"] }),
  ]),
  simlayer("q", "q-mode for emojis").manipulators([
    map("j").toPaste("😅"),
    map("u").toPaste("👍🏼"),
    map("p").to("spacebar", ["left_control", "left_command"]),
  ]),
  simlayer("e").manipulators(
    withCondition(ifApp("com.jetbrains.intellij"))([
      map("h").to("f12", ["left_command", "left_shift"]),
      map("k").to("f1", ["right_command"]),
    ]),
  ),
]);
