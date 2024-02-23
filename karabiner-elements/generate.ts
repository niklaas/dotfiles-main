import {
  layer,
  map,
  rule,
  simlayer,
  withMapper,
  writeToProfile,
} from "https://deno.land/x/karabinerts@1.27.0/deno.ts";

const alphaNumericKeys = (
  "1234567890" +
  "qwertyuiop" +
  "asdfghjkl" +
  "zxcvbnm"
).split("");
const symbols = [
  "grave_accent_and_tilde",
  ...["hyphen", "equal_sign"],
  ...["open_bracket", "close_bracket", "backslash"],
  ...["semicolon", "quote"],
  ...["comma", "period", "slash"],
];
const otherKeys = [
  "tab",
  "delete_or_backspace",
  "return_or_enter",
  "left_arrow",
  "right_arrow",
  "up_arrow",
  "down_arrow",
];
const leftHomeRow = "asdf".split("");
const rightHomeRow = [..."jkl".split(""), "semicolon"];

/**
 * sequence: control < option < command < shift
 */
const homeRowSimLayer = (from_key, to_modifier, homeRowKeys) =>
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
  // rule("caps-lock to left-control, escape if alone").manipulators([
  //   map("caps_lock", "optionalAny").to("left_control").toIfAlone("escape"),
  // ]),
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
  homeRowSimLayer("l", "right_command", rightHomeRow),
  homeRowSimLayer("semicolon", "right_control", rightHomeRow),
  simlayer("spacebar", "space-mode (code)").manipulators([
    map("a").to("open_bracket"), // [
    map("s").to("close_bracket"), // ]
    map("d").to("9", "left_shift"), // (
    map("f").to("0", "right_shift"), // )
    map("j").to("open_bracket", "left_shift"), // {
    map("k").to("close_bracket", "left_shift"), // }
    map("l").to("quote"), // '🤔
    map("semicolon").to("quote", "left_shift"), // " 🤔
    //
    map("e").to(1, "shift_right"), // ! (e)xclamation mark
    map("t").to("grave_accent_and_tilde", "right_shift"), // ~ (t)ilde
    map("g").to("grave_accent_and_tilde"), // ` (g)rave
    map("u").to("hyphen", "left_shift"), // _ (u)nderscore
    map("i").to("equal_sign"), // = (i)s
  ]),
  simlayer("i", "i-mode (text manipulation and selection)").manipulators([
    map("a").to({
      key_code: "left_arrow",
      modifiers: ["left_shift", "option"],
    }),
    map("f").to({
      key_code: "right_arrow",
      modifiers: ["left_shift", "option"],
    }),
  ]),
  simlayer("w", "w-mode (window/desktop)").manipulators([
    map("h").to({ key_code: "left_arrow", modifiers: ["left_control"] }),
    map("l").to({ key_code: "right_arrow", modifiers: ["left_control"] }),
  ]),
  layer("caps_lock", "caps_lock-mode")
    .configKey((v) => v.toIfAlone("escape"), true)
    .manipulators([
      map("u").to("delete_or_backspace"), // (u)ndo
      map("y").to({
        key_code: "delete_or_backspace",
        modifiers: ["left_option"],
      }), // like above but further
      map("i").to("return_or_enter"),
      map("o").to("delete_forward"),
      map("h").to("left_arrow"), // vim left
      map("j").to("down_arrow"), // vim down
      map("k").to("up_arrow"), // vim up
      map("l").to("right_arrow"), // vim right
    ]),
]);

// rule("f to shift").manipulators([
//   map("f", "optionalAny")
//     .to("left_shift")
//     .toIfAlone("f")
//     .parameters({ "basic.to_if_alone_timeout_milliseconds": 100 }),
// ]),
