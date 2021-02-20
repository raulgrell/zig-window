const std = @import("std");
const math = std.math;
const cstr = std.cstr;
const assert = std.debug.assert;

const X = @import("c.zig");

pub fn main() !void {
    const size_hints = X.AllocSizeHints() orelse return error.OutOfMemory;
    const wm_hints = X.AllocWMHints() orelse return error.OutOfMemory;
    const class_hints = X.AllocClassHint() orelse return error.OutOfMemory;
    const display = X.OpenDisplay(0) orelse return error.OutOfMemory;
    defer assert(X.CloseDisplay(display) == 0);

    const screen_num = X.DefaultScreen(display);
    const display_width = try math.cast(u32, X.DisplayWidth(display, screen_num));
    const display_height = X.DisplayHeight(display, screen_num);

    const x = 0;
    const y = 0;
    var width = display_width / 3;
    var height = display_width / 3;

    const border_width = 0;

    const win = X.CreateSimpleWindow(
        display,
        X.RootWindow(display, screen_num),
        x,
        y,
        width,
        height,
        border_width,
        X.BlackPixel(display, screen_num),
        X.WhitePixel(display, screen_num),
    );

    const window_name = [1][*]const u8{c"window name"};
    var windowName: X.TextProperty = undefined;
    if (X.StringListToTextProperty(&window_name, 1, &windowName) == 0)
        return error.OutOfMemory;

    const icon_name = [1][*]const u8{c"icon name"};
    var iconName: X.TextProperty = undefined;
    if (X.StringListToTextProperty(&icon_name, 1, &iconName) == 0)
        return error.OutOfMemory;

    size_hints.flags = X.PPosition | X.PSize | X.PMinSize;
    size_hints.min_width = 200;
    size_hints.min_height = 200;

    wm_hints.flags = X.StateHint | X.InputHint;
    wm_hints.initial_state = X.NormalState;
    wm_hints.input = X.True;

    const appname = c"appname";
    class_hints.res_name = appname;
    class_hints.res_class = c"hellox";

    X.SetWMProperties(display, win, &windowName, &iconName, null, 0, size_hints, wm_hints, class_hints);

    _ = X.SelectInput(
        display,
        win,
        X.ExposureMask | X.KeyPressMask | X.ButtonPressMask | X.StructureNotifyMask,
    );

    const font_info = X.LoadQueryFont(display, c"*");
    if (font_info == 0) return error.NoFont;
    defer _ = X.UnloadFont(display, font_info[0].fid);

    var values: X.GCValues = undefined;
    const gc = X.CreateGC(display, win, 0, &values);
    defer _ = X.FreeGC(display, gc);

    _ = X.SetFont(display, gc, font_info[0].fid);
    _ = X.SetForeground(display, gc, X.BlackPixel(display, screen_num));

    _ = X.MapWindow(display, win);

    while (true) {
        const message = c"Hello, X Window System!";

        var report: X.Event = undefined;
        assert(X.NextEvent(display, &report) == 0);

        switch (report.@"type") {
            X.Expose => {
                if (report.xexpose.count != 0)
                    continue;

                const length = @intCast(u32, X.TextWidth(font_info, message, @intCast(c_int, cstr.len(message))));
                const msg_x = (width - length) / 2;

                const font_height = @intCast(u32, font_info[0].ascent) + @intCast(u32, font_info[0].descent);
                const msg_y = (height + font_height) / 2;

                assert(X.DrawString(
                    display,
                    win,
                    gc,
                    @intCast(c_int, msg_x),
                    @intCast(c_int, msg_y),
                    message,
                    @intCast(c_int, cstr.len(message)),
                ) == 0);
            },
            X.ConfigureNotify => {
                width = @intCast(u32, report.xconfigure.width);
                height = @intCast(u32, report.xconfigure.height);
            },
            else => {},
        }
    }
}
