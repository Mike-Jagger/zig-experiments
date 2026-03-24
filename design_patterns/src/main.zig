const std = @import("std");
const root = @import("root.zig");

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    std.debug.print("Run `zig build tests` to see the design patterns at work", .{});
    try root.bufferedPrint();
}
