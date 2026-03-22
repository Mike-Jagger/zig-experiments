const std = @import("std");
const root = @import("root.zig");

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    std.debug.print("Run `zig build tests` to see the design patterns at work", .{"codebase"});
    try root.bufferedPrint();
}

const ComponentWithContextualHelp = struct {
    ptr: *anyopaque,
    showToolTipFunc: *const fn (self: *anyopaque) anyerror!void,

    const Self = @This();

    fn init(ptr: anytype) Self {
        const T = @TypeOf(ptr);
        const ptr_info = @typeInfo(T);

        const gen = struct {
            pub fn showtoolTip(pointer: *anyopaque) anyerror!void {
                const self: T = @ptrCast(@alignCast(pointer));
                ptr_info.pointer.child.showToolTip(self);
            }
        };

        return .{
            .ptr = ptr,
            .showToolTipFunc = gen.showToolTip,
        };
    }

    fn showToolTip(self: Self) !void {
        self.showToolTipFunc(self.ptr);
    }
};
