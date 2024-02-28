! function(e) {
    var t = e(window),
        o = e("body"),
        n = e("#wrapper"),
        a = e("#header"),
        i = e("#banner");
    breakpoints({
        xlarge: ["1281px", "1680px"],
        large: ["981px", "1280px"],
        medium: ["737px", "980px"],
        small: ["481px", "736px"],
        xsmall: ["361px", "480px"],
        xxsmall: [null, "360px"]
    }), e.fn._parallax = "ie" == browser.name || "edge" == browser.name || browser.mobile ? function() {
        return e(this)
    } : function(t) {
        var o = e(window),
            n = e(this);
        if (0 == this.length || 0 === t) return n;
        if (this.length > 1) {
            for (var a = 0; a < this.length; a++) e(this[a])._parallax(t);
            return n
        }
        return t || (t = .25), n.each((function() {
            var n, a, i = e(this);
            n = function() {
                i.css("background-position", "center 100%, center 100%, center 0px"), o.on("scroll._parallax", (function() {
                    var e = parseInt(o.scrollTop()) - parseInt(i.position().top);
                    i.css("background-position", "center " + e * (-1 * t) + "px")
                }))
            }, a = function() {
                i.css("background-position", ""), o.off("scroll._parallax")
            }, breakpoints.on("<=medium", a), breakpoints.on(">medium", n)
        })), o.off("load._parallax resize._parallax").on("load._parallax resize._parallax", (function() {
            o.trigger("scroll")
        })), e(this)
    }, t.on("load", (function() {
        window.setTimeout((function() {
            o.removeClass("is-preload")
        }), 100)
    })), t.on("unload pagehide", (function() {
        window.setTimeout((function() {
            e(".is-transitioning").removeClass("is-transitioning")
        }), 250)
    })), "ie" != browser.name && "edge" != browser.name || o.addClass("is-ie"), e(".scrolly").scrolly({
        offset: function() {
            return a.height() - 2
        }
    }), e(".tiles > article").each((function() {
        var t, o = e(this),
            a = o.find(".image"),
            i = a.find("img"),
            r = o.find(".link");
        o.css("background-image", "url(" + i.attr("src") + ")"), (t = i.data("position")) && a.css("background-position", t), a.hide(), r.length > 0 && ($x = r.clone().text("").addClass("primary").appendTo(o), (r = r.add($x)).on("click", (function(e) {
            var t = r.attr("href");
            e.stopPropagation(), e.preventDefault(), "_blank" == r.attr("target") ? window.open(t) : (o.addClass("is-transitioning"), n.addClass("is-transitioning"), window.setTimeout((function() {
                location.href = t
            }), 500))
        })))
    })), i.length > 0 && a.hasClass("alt") && (t.on("resize", (function() {
        t.trigger("scroll")
    })), t.on("load", (function() {
        i.scrollex({
            bottom: a.height() + 10,
            terminate: function() {
                a.removeClass("alt")
            },
            enter: function() {
                a.addClass("alt")
            },
            leave: function() {
                a.removeClass("alt"), a.addClass("reveal")
            }
        }), window.setTimeout((function() {
            t.triggerHandler("scroll")
        }), 100)
    }))), i.each((function() {
        var t = e(this),
            o = t.find(".image"),
            n = o.find("img");
        t._parallax(.275), o.length > 0 && (t.css("background-image", "url(" + n.attr("src") + ")"), o.hide())
    }));
    var r, s = e("#menu");
    s.wrapInner('<div class="inner"></div>'), r = s.children(".inner"), s._locked = !1, s._lock = function() {
        return !s._locked && (s._locked = !0, window.setTimeout((function() {
            s._locked = !1
        }), 350), !0)
    }, s._show = function() {
        s._lock() && o.addClass("is-menu-visible")
    }, s._hide = function() {
        s._lock() && o.removeClass("is-menu-visible")
    }, s._toggle = function() {
        s._lock() && o.toggleClass("is-menu-visible")
    }, r.on("click", (function(e) {
        e.stopPropagation()
    })).on("click", "a", (function(t) {
        var o = e(this).attr("href");
        t.preventDefault(), t.stopPropagation(), s._hide(), window.setTimeout((function() {
            window.location.href = o
        }), 250)
    })), s.appendTo(o).on("click", (function(e) {
        e.stopPropagation(), e.preventDefault(), o.removeClass("is-menu-visible")
    })).append('<a class="close" href="#menu">Close</a>'), o.on("click", 'a[href="#menu"]', (function(e) {
        e.stopPropagation(), e.preventDefault(), s._toggle()
    })).on("click", (function(e) {
        s._hide()
    })).on("keydown", (function(e) {
        27 == e.keyCode && s._hide()
    }));
    const l = ["「 In doubt, reboot 」", "「 Viruses are mostly explicitly accepted, but you didn't notice 」", "「 Never trust brands, only reviews 」", "「 Always copy your files, never cut them 」", "「 Update your system if you have some spare time, otherwise it will update when you don't 」", "「 You can't download RAM 」", "「 Most cloud services you use are on land, and even underwater 」", "「 Clean your keyboard throughly at least twice a year, don't ask why 」", "「 Antivirus are malware that hate competition 」", "「 All software is licensed, even if it's free 」", "「 The less social networks you have, the more sane you are 」", "「 There's no way you can be %100 anonymous on the internet 」", "「 A real backup is made by three copies, on two different types of storage, with one copy offsite 」", "「 Data redundancy is not a backup 」", "「 Remembering your passwords is a fatal security flaw, use a password manager instead 」", "「 AI is a misleading commercial term, same as High Definition 」", "「 Automation doesn't imply optimization 」"];
    window.onload = function() {
        const e = Math.floor(Math.random() * l.length),
            t = l[e];
        document.getElementById("random-phrase").textContent = t
    };
    const c = document.getElementById("softwareid"),
        d = document.getElementById("searchInput");
    d.addEventListener("input", (function() {
        c.innerHTML = "";
        const e = d.value.trim().toLowerCase();
        software.filter((t => t.id.toLowerCase().includes(e))).forEach(addCell)
    })), albums.forEach(addCell), document.addEventListener("DOMContentLoaded", (e => {
        document.querySelectorAll(".fedora-button").forEach((e => {
            e.addEventListener("click", (function() {
                const e = this.getAttribute("data-text");
                navigator.clipboard.writeText(e).then((() => {
                    console.log("Text copied to clipboard")
                })).catch((e => {
                    console.error("Error in copying text: ", e)
                }))
            }))
        }))
    })), document.addEventListener("DOMContentLoaded", (e => {
        document.querySelectorAll(".windows-button").forEach((e => {
            e.addEventListener("click", (function() {
                const e = this.getAttribute("data-text");
                navigator.clipboard.writeText(e).then((() => {
                    console.log("Text copied to clipboard")
                })).catch((e => {
                    console.error("Error in copying text: ", e)
                }))
            }))
        }))
    })), document.addEventListener("DOMContentLoaded", (e => {
        document.querySelectorAll(".macos-button").forEach((e => {
            e.addEventListener("click", (function() {
                const e = this.getAttribute("data-text");
                navigator.clipboard.writeText(e).then((() => {
                    console.log("Text copied to clipboard")
                })).catch((e => {
                    console.error("Error in copying text: ", e)
                }))
            }))
        }))
    }))
}(jQuery);