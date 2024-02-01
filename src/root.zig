const std = @import("std");
const testing = std.testing;
pub const c = @cImport({
    @cInclude("libmnl/libmnl.h");
    @cInclude("linux/ethtool_netlink.h");
    @cInclude("linux/genetlink.h");
    @cInclude("linux/hsr_netlink.h");
    @cInclude("linux/nbd-netlink.h");
    @cInclude("linux/rtnetlink.h");
    @cInclude("linux/selinux_netlink.h");
    @cInclude("linux/tipc_netlink.h");
});

test {
    const nl_maybe = c.mnl_socket_open(c.NETLINK_ROUTE);
    if (nl_maybe) |nl| {
        defer _ = c.mnl_socket_close(nl);
    }
}
