const std = @import("std");
const root = @import("root.zig");

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    std.debug.print("Run `zig build tests` to see the design patterns at work", .{});
    try root.bufferedPrint();
}

test "Test Chain of Responsibility" {
    var ok = Button.init(&Component.init(null, "Okay"));

    _ = try ok.componentWithContextualHelp();
}

const ComponentWithContextualHelp = struct {
    ptr: *const anyopaque,
    showToolTipFunc: *const fn (self: *const anyopaque) anyerror!void,

    const Self = @This();

    fn init(ptr: anytype) Self {
        const T = @TypeOf(ptr);
        const ptr_info = @typeInfo(T);

        const gen = struct {
            pub fn showToolTip(pointer: *const anyopaque) anyerror!void {
                const self: T = @ptrCast(@alignCast(pointer));
                ptr_info.pointer.child.showToolTip(self);
            }
        };

        return .{
            .ptr = ptr,
            .showToolTipFunc = gen.showToolTip,
        };
    }

    fn showToolTip(self: *const Self) !void {
        self.showToolTipFunc(self.ptr);
    }
};

const Component = struct {
    container: ?*Container,
    toolTipText: ?[]const u8,

    fn init(container: ?*Container, toolTipText: ?[]const u8) Component {
        return .{
            .container = container orelse null,
            .toolTipText = toolTipText orelse null,
        };
    }

    fn componentWithContextualHelp(self: *const Component) anyerror!ComponentWithContextualHelp {
        if (self.toolTipText) |_| {
            return .init(self);
        } else {
            return self.container.?.*.componentWithContextualHelp();
        }
    }

    fn showToolTip(self: *const Component) void {
        std.debug.print("Message from component: {s}", .{self.toolTipText.?});
    }
};

const Container = struct {
    _last: u8,
    children: [256]Component,

    base: Component,

    fn init(children: ?[256]Component) Container {
        return .{
            ._last = -1,
            .children = children orelse undefined,

            .base = .init(null, null),
        };
    }

    fn add(self: *Container, child: Component) !void {
        self._last.* +| 1;

        self.children[self._last] = child;

        child.container = @This();
    }

    fn componentWithContextualHelp(self: *Container) anyerror!ComponentWithContextualHelp {
        return try self.base.componentWithContextualHelp();
    }
};

const Button: type = struct {
    base: ?*const Component,

    fn init(component: ?*const Component) Button {
        return .{
            .base = component orelse unreachable,
        };
    }

    fn componentWithContextualHelp(self: *Button) !ComponentWithContextualHelp {
        return try self.base.?.*.componentWithContextualHelp();
    }
};

const Panel: type = struct {
    modalHelpText: []const u8,

    base: Container,

    fn init(modalHelpText: ?[]const u8, container: ?Container) Panel {
        return .{
            .modalHelpText = modalHelpText orelse undefined,
            .base = container orelse .init(),
        };
    }

    fn add(self: *Panel, child: Component) !void {
        self.base.add(child);
    }

    fn componentWithContextualHelp(self: *Panel) !ComponentWithContextualHelp {
        return switch (self.modalHelpText) {
            null => try self.base.componentWithContextualHelp(),
            else => .init(self),
        };
    }

    fn showToolTip(self: *const Panel) void {
        std.debug.print("Modal help text: {s}", .{self.modalHelpText});
    }
};

const Dialog: type = struct {
    wikiURL: []const u8,

    base: Container,

    fn init(wikiURL: ?[]const u8, container: ?Container) Panel {
        return .{
            .wikiURL = wikiURL orelse undefined,
            .base = container orelse .init(),
        };
    }

    fn add(self: *Panel, child: Component) !void {
        self.base.add(child);
    }

    fn componentWithContextualHelp(self: *Panel) !ComponentWithContextualHelp {
        return switch (self.wikiURL) {
            null => try self.base.componentWithContextualHelp(),
            else => .init(self),
        };
    }

    fn showToolTip(self: *const Dialog) void {
        std.debug.print("Wikipedia URL: {s}", .{self.wikiURL});
    }
};
