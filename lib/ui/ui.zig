// Utility
const std = @import("std");

pub fn uiInitDefault(size: usize) !uiInitOptions {
    var options = uiInitOptions { .Size = size };
    var err = uiInit(&options);
    if (err != null) {
        std.debug.warn("error initializing libui: {}", err);
        uiFreeInitError(err);
        return error.InitFailed;
    }
    return options;
}

pub fn uiControlCast(control: var) *uiControl {
    return @ptrCast(*uiControl, @alignCast(4, control));
}

// UI
pub const struct_uiInitOptions = extern struct {
    Size: usize,
};
pub const uiInitOptions = struct_uiInitOptions;
pub extern fn uiInit(options: ?*uiInitOptions) ?[*]const u8;
pub extern fn uiUninit() void;
pub extern fn uiFreeInitError(err: ?[*]const u8) void;
pub extern fn uiMain() void;
pub extern fn uiMainSteps() void;
pub extern fn uiMainStep(wait: c_int) c_int;
pub extern fn uiQuit() void;
pub extern fn uiQueueMain(f: ?extern fn(?*c_void) void, data: ?*c_void) void;
pub extern fn uiTimer(milliseconds: c_int, f: ?extern fn(?*c_void) c_int, data: ?*c_void) void;
pub extern fn uiOnShouldQuit(f: ?extern fn(?*c_void) c_int, data: ?*c_void) void;
pub extern fn uiFreeText(text: ?[*]u8) void;

// Control
pub const uiControl = struct_uiControl;
pub const struct_uiControl = extern struct {
    Signature: u32,
    OSSignature: u32,
    TypeSignature: u32,
    Destroy: ?extern fn(?*uiControl) void,
    Handle: ?extern fn(?*uiControl) usize,
    Parent: ?extern fn(?*uiControl) ?*uiControl,
    SetParent: ?extern fn(?*uiControl, ?*uiControl) void,
    Toplevel: ?extern fn(?*uiControl) c_int,
    Visible: ?extern fn(?*uiControl) c_int,
    Show: ?extern fn(?*uiControl) void,
    Hide: ?extern fn(?*uiControl) void,
    Enabled: ?extern fn(?*uiControl) c_int,
    Enable: ?extern fn(?*uiControl) void,
    Disable: ?extern fn(?*uiControl) void,
};
pub extern fn uiControlDestroy(arg0: ?*uiControl) void;
pub extern fn uiControlHandle(arg0: ?*uiControl) usize;
pub extern fn uiControlParent(arg0: ?*uiControl) ?*uiControl;
pub extern fn uiControlSetParent(arg0: ?*uiControl, arg1: ?*uiControl) void;
pub extern fn uiControlToplevel(arg0: ?*uiControl) c_int;
pub extern fn uiControlVisible(arg0: ?*uiControl) c_int;
pub extern fn uiControlShow(arg0: ?*uiControl) void;
pub extern fn uiControlHide(arg0: ?*uiControl) void;
pub extern fn uiControlEnabled(arg0: ?*uiControl) c_int;
pub extern fn uiControlEnable(arg0: ?*uiControl) void;
pub extern fn uiControlDisable(arg0: ?*uiControl) void;
pub extern fn uiAllocControl(n: usize, OSsig: u32, typesig: u32, typenamestr: ?[*]const u8) ?*uiControl;
pub extern fn uiFreeControl(arg0: ?*uiControl) void;
pub extern fn uiControlVerifySetParent(arg0: ?*uiControl, arg1: ?*uiControl) void;
pub extern fn uiControlEnabledToUser(arg0: ?*uiControl) c_int;
pub extern fn uiUserBugCannotSetParentOnToplevel(type_0: ?[*]const u8) void;

// Window
pub const struct_uiWindow = @OpaqueType();
pub const uiWindow = struct_uiWindow;
pub extern fn uiWindowTitle(w: ?*uiWindow) ?[*]u8;
pub extern fn uiWindowSetTitle(w: ?*uiWindow, title: ?[*]const u8) void;
pub extern fn uiWindowContentSize(w: ?*uiWindow, width: ?[*]c_int, height: ?[*]c_int) void;
pub extern fn uiWindowSetContentSize(w: ?*uiWindow, width: c_int, height: c_int) void;
pub extern fn uiWindowFullscreen(w: ?*uiWindow) c_int;
pub extern fn uiWindowSetFullscreen(w: ?*uiWindow, fullscreen: c_int) void;
pub extern fn uiWindowOnContentSizeChanged(w: ?*uiWindow, f: ?extern fn(?*uiWindow, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiWindowOnClosing(w: ?*uiWindow, f: ?extern fn(?*uiWindow, ?*c_void) c_int, data: ?*c_void) void;
pub extern fn uiWindowBorderless(w: ?*uiWindow) c_int;
pub extern fn uiWindowSetBorderless(w: ?*uiWindow, borderless: c_int) void;
pub extern fn uiWindowSetChild(w: ?*uiWindow, child: ?*uiControl) void;
pub extern fn uiWindowMargined(w: ?*uiWindow) c_int;
pub extern fn uiWindowSetMargined(w: ?*uiWindow, margined: c_int) void;
pub extern fn uiNewWindow(title: ?[*]const u8, width: c_int, height: c_int, hasMenubar: c_int) ?*uiWindow;

// Button
pub const struct_uiButton = @OpaqueType();
pub const uiButton = struct_uiButton;
pub extern fn uiButtonText(b: ?*uiButton) ?[*]u8;
pub extern fn uiButtonSetText(b: ?*uiButton, text: ?[*]const u8) void;
pub extern fn uiButtonOnClicked(b: ?*uiButton, f: ?extern fn(?*uiButton, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiNewButton(text: ?[*]const u8) ?*uiButton;

// Box
pub const struct_uiBox = @OpaqueType();
pub const uiBox = struct_uiBox;
pub extern fn uiBoxAppend(b: ?*uiBox, child: ?*uiControl, stretchy: c_int) void;
pub extern fn uiBoxDelete(b: ?*uiBox, index: c_int) void;
pub extern fn uiBoxPadded(b: ?*uiBox) c_int;
pub extern fn uiBoxSetPadded(b: ?*uiBox, padded: c_int) void;
pub extern fn uiNewHorizontalBox() ?*uiBox;
pub extern fn uiNewVerticalBox() ?*uiBox;

// Checkbox
pub const struct_uiCheckbox = @OpaqueType();
pub const uiCheckbox = struct_uiCheckbox;
pub extern fn uiCheckboxText(c: ?*uiCheckbox) ?[*]u8;
pub extern fn uiCheckboxSetText(c: ?*uiCheckbox, text: ?[*]const u8) void;
pub extern fn uiCheckboxOnToggled(c: ?*uiCheckbox, f: ?extern fn(?*uiCheckbox, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiCheckboxChecked(c: ?*uiCheckbox) c_int;
pub extern fn uiCheckboxSetChecked(c: ?*uiCheckbox, checked: c_int) void;
pub extern fn uiNewCheckbox(text: ?[*]const u8) ?*uiCheckbox;

// Entry
pub const struct_uiEntry = @OpaqueType();
pub const uiEntry = struct_uiEntry;
pub extern fn uiEntryText(e: ?*uiEntry) ?[*]u8;
pub extern fn uiEntrySetText(e: ?*uiEntry, text: ?[*]const u8) void;
pub extern fn uiEntryOnChanged(e: ?*uiEntry, f: ?extern fn(?*uiEntry, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiEntryReadOnly(e: ?*uiEntry) c_int;
pub extern fn uiEntrySetReadOnly(e: ?*uiEntry, readonly: c_int) void;
pub extern fn uiNewEntry() ?*uiEntry;
pub extern fn uiNewPasswordEntry() ?*uiEntry;
pub extern fn uiNewSearchEntry() ?*uiEntry;

// Label
pub const struct_uiLabel = @OpaqueType();
pub const uiLabel = struct_uiLabel;
pub extern fn uiLabelText(l: ?*uiLabel) ?[*]u8;
pub extern fn uiLabelSetText(l: ?*uiLabel, text: ?[*]const u8) void;
pub extern fn uiNewLabel(text: ?[*]const u8) ?*uiLabel;

// Tab
pub const struct_uiTab = @OpaqueType();
pub const uiTab = struct_uiTab;
pub extern fn uiTabAppend(t: ?*uiTab, name: ?[*]const u8, c: ?*uiControl) void;
pub extern fn uiTabInsertAt(t: ?*uiTab, name: ?[*]const u8, before: c_int, c: ?*uiControl) void;
pub extern fn uiTabDelete(t: ?*uiTab, index: c_int) void;
pub extern fn uiTabNumPages(t: ?*uiTab) c_int;
pub extern fn uiTabMargined(t: ?*uiTab, page: c_int) c_int;
pub extern fn uiTabSetMargined(t: ?*uiTab, page: c_int, margined: c_int) void;
pub extern fn uiNewTab() ?*uiTab;

// Group
pub const struct_uiGroup = @OpaqueType();
pub const uiGroup = struct_uiGroup;
pub extern fn uiGroupTitle(g: ?*uiGroup) ?[*]u8;
pub extern fn uiGroupSetTitle(g: ?*uiGroup, title: ?[*]const u8) void;
pub extern fn uiGroupSetChild(g: ?*uiGroup, c: ?*uiControl) void;
pub extern fn uiGroupMargined(g: ?*uiGroup) c_int;
pub extern fn uiGroupSetMargined(g: ?*uiGroup, margined: c_int) void;
pub extern fn uiNewGroup(title: ?[*]const u8) ?*uiGroup;

// Spinbox
pub const struct_uiSpinbox = @OpaqueType();
pub const uiSpinbox = struct_uiSpinbox;
pub extern fn uiSpinboxValue(s: ?*uiSpinbox) c_int;
pub extern fn uiSpinboxSetValue(s: ?*uiSpinbox, value: c_int) void;
pub extern fn uiSpinboxOnChanged(s: ?*uiSpinbox, f: ?extern fn(?*uiSpinbox, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiNewSpinbox(min: c_int, max: c_int) ?*uiSpinbox;

// Slider
pub const struct_uiSlider = @OpaqueType();
pub const uiSlider = struct_uiSlider;
pub extern fn uiSliderValue(s: ?*uiSlider) c_int;
pub extern fn uiSliderSetValue(s: ?*uiSlider, value: c_int) void;
pub extern fn uiSliderOnChanged(s: ?*uiSlider, f: ?extern fn(?*uiSlider, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiNewSlider(min: c_int, max: c_int) ?*uiSlider;

// ProgressBar
pub const struct_uiProgressBar = @OpaqueType();
pub const uiProgressBar = struct_uiProgressBar;
pub extern fn uiProgressBarValue(p: ?*uiProgressBar) c_int;
pub extern fn uiProgressBarSetValue(p: ?*uiProgressBar, n: c_int) void;
pub extern fn uiNewProgressBar() ?*uiProgressBar;

// Separator
pub const struct_uiSeparator = @OpaqueType();
pub const uiSeparator = struct_uiSeparator;
pub extern fn uiNewHorizontalSeparator() ?*uiSeparator;
pub extern fn uiNewVerticalSeparator() ?*uiSeparator;

// Combobox
pub const struct_uiCombobox = @OpaqueType();
pub const uiCombobox = struct_uiCombobox;
pub extern fn uiComboboxAppend(c: ?*uiCombobox, text: ?[*]const u8) void;
pub extern fn uiComboboxSelected(c: ?*uiCombobox) c_int;
pub extern fn uiComboboxSetSelected(c: ?*uiCombobox, n: c_int) void;
pub extern fn uiComboboxOnSelected(c: ?*uiCombobox, f: ?extern fn(?*uiCombobox, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiNewCombobox() ?*uiCombobox;

// EditableCombobox
pub const struct_uiEditableCombobox = @OpaqueType();
pub const uiEditableCombobox = struct_uiEditableCombobox;
pub extern fn uiEditableComboboxAppend(c: ?*uiEditableCombobox, text: ?[*]const u8) void;
pub extern fn uiEditableComboboxText(c: ?*uiEditableCombobox) ?[*]u8;
pub extern fn uiEditableComboboxSetText(c: ?*uiEditableCombobox, text: ?[*]const u8) void;
pub extern fn uiEditableComboboxOnChanged(c: ?*uiEditableCombobox, f: ?extern fn(?*uiEditableCombobox, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiNewEditableCombobox() ?*uiEditableCombobox;

// RadioButtons
pub const struct_uiRadioButtons = @OpaqueType();
pub const uiRadioButtons = struct_uiRadioButtons;
pub extern fn uiRadioButtonsAppend(r: ?*uiRadioButtons, text: ?[*]const u8) void;
pub extern fn uiRadioButtonsSelected(r: ?*uiRadioButtons) c_int;
pub extern fn uiRadioButtonsSetSelected(r: ?*uiRadioButtons, n: c_int) void;
pub extern fn uiRadioButtonsOnSelected(r: ?*uiRadioButtons, f: ?extern fn(?*uiRadioButtons, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiNewRadioButtons() ?*uiRadioButtons;
pub const struct_tm = @OpaqueType();

// DateTimePicker
pub const struct_uiDateTimePicker = @OpaqueType();
pub const uiDateTimePicker = struct_uiDateTimePicker;
pub extern fn uiDateTimePickerTime(d: ?*uiDateTimePicker, time: ?*struct_tm) void;
pub extern fn uiDateTimePickerSetTime(d: ?*uiDateTimePicker, time: ?*const struct_tm) void;
pub extern fn uiDateTimePickerOnChanged(d: ?*uiDateTimePicker, f: ?extern fn(?*uiDateTimePicker, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiNewDateTimePicker() ?*uiDateTimePicker;
pub extern fn uiNewDatePicker() ?*uiDateTimePicker;
pub extern fn uiNewTimePicker() ?*uiDateTimePicker;

// MultilineEntry
pub const struct_uiMultilineEntry = @OpaqueType();
pub const uiMultilineEntry = struct_uiMultilineEntry;
pub extern fn uiMultilineEntryText(e: ?*uiMultilineEntry) ?[*]u8;
pub extern fn uiMultilineEntrySetText(e: ?*uiMultilineEntry, text: ?[*]const u8) void;
pub extern fn uiMultilineEntryAppend(e: ?*uiMultilineEntry, text: ?[*]const u8) void;
pub extern fn uiMultilineEntryOnChanged(e: ?*uiMultilineEntry, f: ?extern fn(?*uiMultilineEntry, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiMultilineEntryReadOnly(e: ?*uiMultilineEntry) c_int;
pub extern fn uiMultilineEntrySetReadOnly(e: ?*uiMultilineEntry, readonly: c_int) void;
pub extern fn uiNewMultilineEntry() ?*uiMultilineEntry;
pub extern fn uiNewNonWrappingMultilineEntry() ?*uiMultilineEntry;

// MenuItem
pub const struct_uiMenuItem = @OpaqueType();
pub const uiMenuItem = struct_uiMenuItem;
pub extern fn uiMenuItemEnable(m: ?*uiMenuItem) void;
pub extern fn uiMenuItemDisable(m: ?*uiMenuItem) void;
pub extern fn uiMenuItemOnClicked(m: ?*uiMenuItem, f: ?extern fn(?*uiMenuItem, ?*uiWindow, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiMenuItemChecked(m: ?*uiMenuItem) c_int;
pub extern fn uiMenuItemSetChecked(m: ?*uiMenuItem, checked: c_int) void;

// Menu
pub const struct_uiMenu = @OpaqueType();
pub const uiMenu = struct_uiMenu;
pub extern fn uiMenuAppendItem(m: ?*uiMenu, name: ?[*]const u8) ?*uiMenuItem;
pub extern fn uiMenuAppendCheckItem(m: ?*uiMenu, name: ?[*]const u8) ?*uiMenuItem;
pub extern fn uiMenuAppendQuitItem(m: ?*uiMenu) ?*uiMenuItem;
pub extern fn uiMenuAppendPreferencesItem(m: ?*uiMenu) ?*uiMenuItem;
pub extern fn uiMenuAppendAboutItem(m: ?*uiMenu) ?*uiMenuItem;
pub extern fn uiMenuAppendSeparator(m: ?*uiMenu) void;
pub extern fn uiNewMenu(name: ?[*]const u8) ?*uiMenu;
pub extern fn uiOpenFile(parent: ?*uiWindow) ?[*]u8;
pub extern fn uiSaveFile(parent: ?*uiWindow) ?[*]u8;
pub extern fn uiMsgBox(parent: ?*uiWindow, title: ?[*]const u8, description: ?[*]const u8) void;
pub extern fn uiMsgBoxError(parent: ?*uiWindow, title: ?[*]const u8, description: ?[*]const u8) void;

// Drawing
pub const struct_uiArea = @OpaqueType();
pub const uiArea = struct_uiArea;
pub const uiAreaHandler = struct_uiAreaHandler;
pub const struct_uiDrawContext = @OpaqueType();
pub const uiDrawContext = struct_uiDrawContext;
pub const struct_uiAreaDrawParams = extern struct {
    Context: ?*uiDrawContext,
    AreaWidth: f64,
    AreaHeight: f64,
    ClipX: f64,
    ClipY: f64,
    ClipWidth: f64,
    ClipHeight: f64,
};
pub const uiAreaDrawParams = struct_uiAreaDrawParams;
pub const uiModifiers = c_uint;
pub const struct_uiAreaMouseEvent = extern struct {
    X: f64,
    Y: f64,
    AreaWidth: f64,
    AreaHeight: f64,
    Down: c_int,
    Up: c_int,
    Count: c_int,
    Modifiers: uiModifiers,
    Held1To64: u64,
};
pub const uiAreaMouseEvent = struct_uiAreaMouseEvent;
pub const uiExtKey = c_uint;
pub const struct_uiAreaKeyEvent = extern struct {
    Key: u8,
    ExtKey: uiExtKey,
    Modifier: uiModifiers,
    Modifiers: uiModifiers,
    Up: c_int,
};
pub const uiAreaKeyEvent = struct_uiAreaKeyEvent;
pub const struct_uiAreaHandler = extern struct {
    Draw: ?extern fn(?[*]uiAreaHandler, ?*uiArea, ?[*]uiAreaDrawParams) void,
    MouseEvent: ?extern fn(?[*]uiAreaHandler, ?*uiArea, ?[*]uiAreaMouseEvent) void,
    MouseCrossed: ?extern fn(?[*]uiAreaHandler, ?*uiArea, c_int) void,
    DragBroken: ?extern fn(?[*]uiAreaHandler, ?*uiArea) void,
    KeyEvent: ?extern fn(?[*]uiAreaHandler, ?*uiArea, ?[*]uiAreaKeyEvent) c_int,
};
pub const uiWindowResizeEdge = c_uint;
pub const uiWindowResizeEdgeLeft = 0;
pub const uiWindowResizeEdgeTop = 1;
pub const uiWindowResizeEdgeRight = 2;
pub const uiWindowResizeEdgeBottom = 3;
pub const uiWindowResizeEdgeTopLeft = 4;
pub const uiWindowResizeEdgeTopRight = 5;
pub const uiWindowResizeEdgeBottomLeft = 6;
pub const uiWindowResizeEdgeBottomRight = 7;
pub extern fn uiAreaSetSize(a: ?*uiArea, width: c_int, height: c_int) void;
pub extern fn uiAreaQueueRedrawAll(a: ?*uiArea) void;
pub extern fn uiAreaScrollTo(a: ?*uiArea, x: f64, y: f64, width: f64, height: f64) void;
pub extern fn uiAreaBeginUserWindowMove(a: ?*uiArea) void;
pub extern fn uiAreaBeginUserWindowResize(a: ?*uiArea, edge: uiWindowResizeEdge) void;
pub extern fn uiNewArea(ah: ?[*]uiAreaHandler) ?*uiArea;
pub extern fn uiNewScrollingArea(ah: ?[*]uiAreaHandler, width: c_int, height: c_int) ?*uiArea;
pub const struct_uiDrawPath = @OpaqueType();
pub const uiDrawPath = struct_uiDrawPath;
pub const uiDrawBrushType = c_uint;
pub const struct_uiDrawBrushGradientStop = extern struct {
    Pos: f64,
    R: f64,
    G: f64,
    B: f64,
    A: f64,
};
pub const uiDrawBrushGradientStop = struct_uiDrawBrushGradientStop;
pub const struct_uiDrawBrush = extern struct {
    Type: uiDrawBrushType,
    R: f64,
    G: f64,
    B: f64,
    A: f64,
    X0: f64,
    Y0: f64,
    X1: f64,
    Y1: f64,
    OuterRadius: f64,
    Stops: ?[*]uiDrawBrushGradientStop,
    NumStops: usize,
};
pub const uiDrawBrush = struct_uiDrawBrush;
pub const uiDrawLineCap = c_uint;
pub const uiDrawLineJoin = c_uint;
pub const struct_uiDrawStrokeParams = extern struct {
    Cap: uiDrawLineCap,
    Join: uiDrawLineJoin,
    Thickness: f64,
    MiterLimit: f64,
    Dashes: ?[*]f64,
    NumDashes: usize,
    DashPhase: f64,
};
pub const uiDrawStrokeParams = struct_uiDrawStrokeParams;
pub const struct_uiDrawMatrix = extern struct {
    M11: f64,
    M12: f64,
    M21: f64,
    M22: f64,
    M31: f64,
    M32: f64,
};
pub const uiDrawMatrix = struct_uiDrawMatrix;
pub const uiDrawBrushTypeSolid = 0;
pub const uiDrawBrushTypeLinearGradient = 1;
pub const uiDrawBrushTypeRadialGradient = 2;
pub const uiDrawBrushTypeImage = 3;
pub const uiDrawLineCapFlat = 0;
pub const uiDrawLineCapRound = 1;
pub const uiDrawLineCapSquare = 2;
pub const uiDrawLineJoinMiter = 0;
pub const uiDrawLineJoinRound = 1;
pub const uiDrawLineJoinBevel = 2;
pub const uiDrawFillMode = c_uint;
pub const uiDrawFillModeWinding = 0;
pub const uiDrawFillModeAlternate = 1;
pub extern fn uiDrawNewPath(fillMode: uiDrawFillMode) ?*uiDrawPath;
pub extern fn uiDrawFreePath(p: ?*uiDrawPath) void;
pub extern fn uiDrawPathNewFigure(p: ?*uiDrawPath, x: f64, y: f64) void;
pub extern fn uiDrawPathNewFigureWithArc(p: ?*uiDrawPath, xCenter: f64, yCenter: f64, radius: f64, startAngle: f64, sweep: f64, negative: c_int) void;
pub extern fn uiDrawPathLineTo(p: ?*uiDrawPath, x: f64, y: f64) void;
pub extern fn uiDrawPathArcTo(p: ?*uiDrawPath, xCenter: f64, yCenter: f64, radius: f64, startAngle: f64, sweep: f64, negative: c_int) void;
pub extern fn uiDrawPathBezierTo(p: ?*uiDrawPath, c1x: f64, c1y: f64, c2x: f64, c2y: f64, endX: f64, endY: f64) void;
pub extern fn uiDrawPathCloseFigure(p: ?*uiDrawPath) void;
pub extern fn uiDrawPathAddRectangle(p: ?*uiDrawPath, x: f64, y: f64, width: f64, height: f64) void;
pub extern fn uiDrawPathEnd(p: ?*uiDrawPath) void;
pub extern fn uiDrawStroke(c: ?*uiDrawContext, path: ?*uiDrawPath, b: ?[*]uiDrawBrush, p: ?[*]uiDrawStrokeParams) void;
pub extern fn uiDrawFill(c: ?*uiDrawContext, path: ?*uiDrawPath, b: ?[*]uiDrawBrush) void;
pub extern fn uiDrawMatrixSetIdentity(m: ?[*]uiDrawMatrix) void;
pub extern fn uiDrawMatrixTranslate(m: ?[*]uiDrawMatrix, x: f64, y: f64) void;
pub extern fn uiDrawMatrixScale(m: ?[*]uiDrawMatrix, xCenter: f64, yCenter: f64, x: f64, y: f64) void;
pub extern fn uiDrawMatrixRotate(m: ?[*]uiDrawMatrix, x: f64, y: f64, amount: f64) void;
pub extern fn uiDrawMatrixSkew(m: ?[*]uiDrawMatrix, x: f64, y: f64, xamount: f64, yamount: f64) void;
pub extern fn uiDrawMatrixMultiply(dest: ?[*]uiDrawMatrix, src: ?[*]uiDrawMatrix) void;
pub extern fn uiDrawMatrixInvertible(m: ?[*]uiDrawMatrix) c_int;
pub extern fn uiDrawMatrixInvert(m: ?[*]uiDrawMatrix) c_int;
pub extern fn uiDrawMatrixTransformPoint(m: ?[*]uiDrawMatrix, x: ?[*]f64, y: ?[*]f64) void;
pub extern fn uiDrawMatrixTransformSize(m: ?[*]uiDrawMatrix, x: ?[*]f64, y: ?[*]f64) void;
pub extern fn uiDrawTransform(c: ?*uiDrawContext, m: ?[*]uiDrawMatrix) void;
pub extern fn uiDrawClip(c: ?*uiDrawContext, path: ?*uiDrawPath) void;
pub extern fn uiDrawSave(c: ?*uiDrawContext) void;
pub extern fn uiDrawRestore(c: ?*uiDrawContext) void;

// Attributes
pub const struct_uiAttribute = @OpaqueType();
pub const uiAttribute = struct_uiAttribute;
pub extern fn uiFreeAttribute(a: ?*uiAttribute) void;
pub const uiAttributeType = c_uint;
pub const uiAttributeTypeFamily = 0;
pub const uiAttributeTypeSize = 1;
pub const uiAttributeTypeWeight = 2;
pub const uiAttributeTypeItalic = 3;
pub const uiAttributeTypeStretch = 4;
pub const uiAttributeTypeColor = 5;
pub const uiAttributeTypeBackground = 6;
pub const uiAttributeTypeUnderline = 7;
pub const uiAttributeTypeUnderlineColor = 8;
pub const uiAttributeTypeFeatures = 9;
pub extern fn uiAttributeGetType(a: ?*const uiAttribute) uiAttributeType;
pub extern fn uiNewFamilyAttribute(family: ?[*]const u8) ?*uiAttribute;
pub extern fn uiAttributeFamily(a: ?*const uiAttribute) ?[*]const u8;
pub extern fn uiNewSizeAttribute(size: f64) ?*uiAttribute;
pub extern fn uiAttributeSize(a: ?*const uiAttribute) f64;
pub const uiTextWeight = c_uint;
pub const uiTextWeightMinimum = 0;
pub const uiTextWeightThin = 100;
pub const uiTextWeightUltraLight = 200;
pub const uiTextWeightLight = 300;
pub const uiTextWeightBook = 350;
pub const uiTextWeightNormal = 400;
pub const uiTextWeightMedium = 500;
pub const uiTextWeightSemiBold = 600;
pub const uiTextWeightBold = 700;
pub const uiTextWeightUltraBold = 800;
pub const uiTextWeightHeavy = 900;
pub const uiTextWeightUltraHeavy = 950;
pub const uiTextWeightMaximum = 1000;
pub extern fn uiNewWeightAttribute(weight: uiTextWeight) ?*uiAttribute;
pub extern fn uiAttributeWeight(a: ?*const uiAttribute) uiTextWeight;
pub const uiTextItalic = c_uint;
pub const uiTextItalicNormal = 0;
pub const uiTextItalicOblique = 1;
pub const uiTextItalicItalic = 2;
pub extern fn uiNewItalicAttribute(italic: uiTextItalic) ?*uiAttribute;
pub extern fn uiAttributeItalic(a: ?*const uiAttribute) uiTextItalic;
pub const uiTextStretch = c_uint;
pub const uiTextStretchUltraCondensed = 0;
pub const uiTextStretchExtraCondensed = 1;
pub const uiTextStretchCondensed = 2;
pub const uiTextStretchSemiCondensed = 3;
pub const uiTextStretchNormal = 4;
pub const uiTextStretchSemiExpanded = 5;
pub const uiTextStretchExpanded = 6;
pub const uiTextStretchExtraExpanded = 7;
pub const uiTextStretchUltraExpanded = 8;
pub extern fn uiNewStretchAttribute(stretch: uiTextStretch) ?*uiAttribute;
pub extern fn uiAttributeStretch(a: ?*const uiAttribute) uiTextStretch;
pub extern fn uiNewColorAttribute(r: f64, g: f64, b: f64, a: f64) ?*uiAttribute;
pub extern fn uiAttributeColor(a: ?*const uiAttribute, r: ?[*]f64, g: ?[*]f64, b: ?[*]f64, alpha: ?[*]f64) void;
pub extern fn uiNewBackgroundAttribute(r: f64, g: f64, b: f64, a: f64) ?*uiAttribute;
pub const uiUnderline = c_uint;
pub const uiUnderlineNone = 0;
pub const uiUnderlineSingle = 1;
pub const uiUnderlineDouble = 2;
pub const uiUnderlineSuggestion = 3;
pub extern fn uiNewUnderlineAttribute(u: uiUnderline) ?*uiAttribute;
pub extern fn uiAttributeUnderline(a: ?*const uiAttribute) uiUnderline;
pub const uiUnderlineColor = c_uint;
pub const uiUnderlineColorCustom = 0;
pub const uiUnderlineColorSpelling = 1;
pub const uiUnderlineColorGrammar = 2;
pub const uiUnderlineColorAuxiliary = 3;
pub extern fn uiNewUnderlineColorAttribute(u: uiUnderlineColor, r: f64, g: f64, b: f64, a: f64) ?*uiAttribute;
pub extern fn uiAttributeUnderlineColor(a: ?*const uiAttribute, u: ?[*]uiUnderlineColor, r: ?[*]f64, g: ?[*]f64, b: ?[*]f64, alpha: ?[*]f64) void;
pub const struct_uiOpenTypeFeatures = @OpaqueType();
pub const uiOpenTypeFeatures = struct_uiOpenTypeFeatures;
pub const uiOpenTypeFeaturesForEachFunc = ?extern fn(?*const uiOpenTypeFeatures, u8, u8, u8, u8, u32, ?*c_void) uiForEach;
pub extern fn uiNewOpenTypeFeatures() ?*uiOpenTypeFeatures;
pub extern fn uiFreeOpenTypeFeatures(otf: ?*uiOpenTypeFeatures) void;
pub extern fn uiOpenTypeFeaturesClone(otf: ?*const uiOpenTypeFeatures) ?*uiOpenTypeFeatures;
pub extern fn uiOpenTypeFeaturesAdd(otf: ?*uiOpenTypeFeatures, a: u8, b: u8, c: u8, d: u8, value: u32) void;
pub extern fn uiOpenTypeFeaturesRemove(otf: ?*uiOpenTypeFeatures, a: u8, b: u8, c: u8, d: u8) void;
pub extern fn uiOpenTypeFeaturesGet(otf: ?*const uiOpenTypeFeatures, a: u8, b: u8, c: u8, d: u8, value: ?[*]u32) c_int;
pub extern fn uiOpenTypeFeaturesForEach(otf: ?*const uiOpenTypeFeatures, f: uiOpenTypeFeaturesForEachFunc, data: ?*c_void) void;
pub extern fn uiNewFeaturesAttribute(otf: ?*const uiOpenTypeFeatures) ?*uiAttribute;
pub extern fn uiAttributeFeatures(a: ?*const uiAttribute) ?*const uiOpenTypeFeatures;
pub const struct_uiAttributedString = @OpaqueType();
pub const uiAttributedString = struct_uiAttributedString;
pub const uiAttributedStringForEachAttributeFunc = ?extern fn(?*const uiAttributedString, ?*const uiAttribute, usize, usize, ?*c_void) uiForEach;
pub extern fn uiNewAttributedString(initialString: ?[*]const u8) ?*uiAttributedString;
pub extern fn uiFreeAttributedString(s: ?*uiAttributedString) void;
pub extern fn uiAttributedStringString(s: ?*const uiAttributedString) ?[*]const u8;
pub extern fn uiAttributedStringLen(s: ?*const uiAttributedString) usize;
pub extern fn uiAttributedStringAppendUnattributed(s: ?*uiAttributedString, str: ?[*]const u8) void;
pub extern fn uiAttributedStringInsertAtUnattributed(s: ?*uiAttributedString, str: ?[*]const u8, at: usize) void;
pub extern fn uiAttributedStringDelete(s: ?*uiAttributedString, start: usize, end: usize) void;
pub extern fn uiAttributedStringSetAttribute(s: ?*uiAttributedString, a: ?*uiAttribute, start: usize, end: usize) void;
pub extern fn uiAttributedStringForEachAttribute(s: ?*const uiAttributedString, f: uiAttributedStringForEachAttributeFunc, data: ?*c_void) void;
pub extern fn uiAttributedStringNumGraphemes(s: ?*uiAttributedString) usize;
pub extern fn uiAttributedStringByteIndexToGrapheme(s: ?*uiAttributedString, pos: usize) usize;
pub extern fn uiAttributedStringGraphemeToByteIndex(s: ?*uiAttributedString, pos: usize) usize;
pub const struct_uiFontDescriptor = extern struct {
    Family: ?[*]u8,
    Size: f64,
    Weight: uiTextWeight,
    Italic: uiTextItalic,
    Stretch: uiTextStretch,
};
pub const uiFontDescriptor = struct_uiFontDescriptor;
pub const struct_uiDrawTextLayout = @OpaqueType();
pub const uiDrawTextLayout = struct_uiDrawTextLayout;
pub const uiDrawTextAlign = c_uint;
pub const uiDrawTextAlignLeft = 0;
pub const uiDrawTextAlignCenter = 1;
pub const uiDrawTextAlignRight = 2;
pub const struct_uiDrawTextLayoutParams = extern struct {
    String: ?*uiAttributedString,
    DefaultFont: ?[*]uiFontDescriptor,
    Width: f64,
    Align: uiDrawTextAlign,
};
pub const uiDrawTextLayoutParams = struct_uiDrawTextLayoutParams;
pub extern fn uiDrawNewTextLayout(params: ?[*]uiDrawTextLayoutParams) ?*uiDrawTextLayout;
pub extern fn uiDrawFreeTextLayout(tl: ?*uiDrawTextLayout) void;
pub extern fn uiDrawText(c: ?*uiDrawContext, tl: ?*uiDrawTextLayout, x: f64, y: f64) void;
pub extern fn uiDrawTextLayoutExtents(tl: ?*uiDrawTextLayout, width: ?[*]f64, height: ?[*]f64) void;
pub const struct_uiFontButton = @OpaqueType();
pub const uiFontButton = struct_uiFontButton;
pub extern fn uiFontButtonFont(b: ?*uiFontButton, desc: ?[*]uiFontDescriptor) void;
pub extern fn uiFontButtonOnChanged(b: ?*uiFontButton, f: ?extern fn(?*uiFontButton, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiNewFontButton() ?*uiFontButton;
pub extern fn uiFreeFontButtonFont(desc: ?[*]uiFontDescriptor) void;

// Input
pub const uiModifierCtrl = 1;
pub const uiModifierAlt = 2;
pub const uiModifierShift = 4;
pub const uiModifierSuper = 8;
pub const uiExtKeyEscape = 1;
pub const uiExtKeyInsert = 2;
pub const uiExtKeyDelete = 3;
pub const uiExtKeyHome = 4;
pub const uiExtKeyEnd = 5;
pub const uiExtKeyPageUp = 6;
pub const uiExtKeyPageDown = 7;
pub const uiExtKeyUp = 8;
pub const uiExtKeyDown = 9;
pub const uiExtKeyLeft = 10;
pub const uiExtKeyRight = 11;
pub const uiExtKeyF1 = 12;
pub const uiExtKeyF2 = 13;
pub const uiExtKeyF3 = 14;
pub const uiExtKeyF4 = 15;
pub const uiExtKeyF5 = 16;
pub const uiExtKeyF6 = 17;
pub const uiExtKeyF7 = 18;
pub const uiExtKeyF8 = 19;
pub const uiExtKeyF9 = 20;
pub const uiExtKeyF10 = 21;
pub const uiExtKeyF11 = 22;
pub const uiExtKeyF12 = 23;
pub const uiExtKeyN0 = 24;
pub const uiExtKeyN1 = 25;
pub const uiExtKeyN2 = 26;
pub const uiExtKeyN3 = 27;
pub const uiExtKeyN4 = 28;
pub const uiExtKeyN5 = 29;
pub const uiExtKeyN6 = 30;
pub const uiExtKeyN7 = 31;
pub const uiExtKeyN8 = 32;
pub const uiExtKeyN9 = 33;
pub const uiExtKeyNDot = 34;
pub const uiExtKeyNEnter = 35;
pub const uiExtKeyNAdd = 36;
pub const uiExtKeyNSubtract = 37;
pub const uiExtKeyNMultiply = 38;
pub const uiExtKeyNDivide = 39;

// ColorButton
pub const struct_uiColorButton = @OpaqueType();
pub const uiColorButton = struct_uiColorButton;
pub extern fn uiColorButtonColor(b: ?*uiColorButton, r: ?[*]f64, g: ?[*]f64, bl: ?[*]f64, a: ?[*]f64) void;
pub extern fn uiColorButtonSetColor(b: ?*uiColorButton, r: f64, g: f64, bl: f64, a: f64) void;
pub extern fn uiColorButtonOnChanged(b: ?*uiColorButton, f: ?extern fn(?*uiColorButton, ?*c_void) void, data: ?*c_void) void;
pub extern fn uiNewColorButton() ?*uiColorButton;

// Form
pub const struct_uiForm = @OpaqueType();
pub const uiForm = struct_uiForm;
pub extern fn uiFormAppend(f: ?*uiForm, label: ?[*]const u8, c: ?*uiControl, stretchy: c_int) void;
pub extern fn uiFormDelete(f: ?*uiForm, index: c_int) void;
pub extern fn uiFormPadded(f: ?*uiForm) c_int;
pub extern fn uiFormSetPadded(f: ?*uiForm, padded: c_int) void;
pub extern fn uiNewForm() ?*uiForm;
pub const uiAlign = c_uint;
pub const uiAlignFill = 0;
pub const uiAlignStart = 1;
pub const uiAlignCenter = 2;
pub const uiAlignEnd = 3;
pub const uiAt = c_uint;
pub const uiAtLeading = 0;
pub const uiAtTop = 1;
pub const uiAtTrailing = 2;
pub const uiAtBottom = 3;

// Grid
pub const struct_uiGrid = @OpaqueType();
pub const uiGrid = struct_uiGrid;
pub extern fn uiGridAppend(g: ?*uiGrid, c: ?*uiControl, left: c_int, top: c_int, xspan: c_int, yspan: c_int, hexpand: c_int, halign: uiAlign, vexpand: c_int, valign: uiAlign) void;
pub extern fn uiGridInsertAt(g: ?*uiGrid, c: ?*uiControl, existing: ?*uiControl, at: uiAt, xspan: c_int, yspan: c_int, hexpand: c_int, halign: uiAlign, vexpand: c_int, valign: uiAlign) void;
pub extern fn uiGridPadded(g: ?*uiGrid) c_int;
pub extern fn uiGridSetPadded(g: ?*uiGrid, padded: c_int) void;
pub extern fn uiNewGrid() ?*uiGrid;

// Image
pub const struct_uiImage = @OpaqueType();
pub const uiImage = struct_uiImage;
pub extern fn uiNewImage(width: f64, height: f64) ?*uiImage;
pub extern fn uiFreeImage(i: ?*uiImage) void;
pub extern fn uiImageAppend(i: ?*uiImage, pixels: ?*c_void, pixelWidth: c_int, pixelHeight: c_int, byteStride: c_int) void;

// Table
pub const struct_uiTableValue = @OpaqueType();
pub const uiTableValue = struct_uiTableValue;
pub extern fn uiFreeTableValue(v: ?*uiTableValue) void;
pub const uiTableValueType = c_uint;
pub const uiTableValueTypeString = 0;
pub const uiTableValueTypeImage = 1;
pub const uiTableValueTypeInt = 2;
pub const uiTableValueTypeColor = 3;
pub extern fn uiTableValueGetType(v: ?*const uiTableValue) uiTableValueType;
pub extern fn uiNewTableValueString(str: ?[*]const u8) ?*uiTableValue;
pub extern fn uiTableValueString(v: ?*const uiTableValue) ?[*]const u8;
pub extern fn uiNewTableValueImage(img: ?*uiImage) ?*uiTableValue;
pub extern fn uiTableValueImage(v: ?*const uiTableValue) ?*uiImage;
pub extern fn uiNewTableValueInt(i: c_int) ?*uiTableValue;
pub extern fn uiTableValueInt(v: ?*const uiTableValue) c_int;
pub extern fn uiNewTableValueColor(r: f64, g: f64, b: f64, a: f64) ?*uiTableValue;
pub extern fn uiTableValueColor(v: ?*const uiTableValue, r: ?[*]f64, g: ?[*]f64, b: ?[*]f64, a: ?[*]f64) void;
pub const struct_uiTableModel = @OpaqueType();
pub const uiTableModel = struct_uiTableModel;
pub const uiTableModelHandler = struct_uiTableModelHandler;
pub const struct_uiTableModelHandler = extern struct {
    NumColumns: ?extern fn(?[*]uiTableModelHandler, ?*uiTableModel) c_int,
    ColumnType: ?extern fn(?[*]uiTableModelHandler, ?*uiTableModel, c_int) uiTableValueType,
    NumRows: ?extern fn(?[*]uiTableModelHandler, ?*uiTableModel) c_int,
    CellValue: ?extern fn(?[*]uiTableModelHandler, ?*uiTableModel, c_int, c_int) ?*uiTableValue,
    SetCellValue: ?extern fn(?[*]uiTableModelHandler, ?*uiTableModel, c_int, c_int, ?*const uiTableValue) void,
};
pub extern fn uiNewTableModel(mh: ?[*]uiTableModelHandler) ?*uiTableModel;
pub extern fn uiFreeTableModel(m: ?*uiTableModel) void;
pub extern fn uiTableModelRowInserted(m: ?*uiTableModel, newIndex: c_int) void;
pub extern fn uiTableModelRowChanged(m: ?*uiTableModel, index: c_int) void;
pub extern fn uiTableModelRowDeleted(m: ?*uiTableModel, oldIndex: c_int) void;
pub const struct_uiTableTextColumnOptionalParams = extern struct {
    ColorModelColumn: c_int,
};
pub const uiTableTextColumnOptionalParams = struct_uiTableTextColumnOptionalParams;
pub const struct_uiTableParams = extern struct {
    Model: ?*uiTableModel,
    RowBackgroundColorModelColumn: c_int,
};
pub const uiTableParams = struct_uiTableParams;
pub const struct_uiTable = @OpaqueType();
pub const uiTable = struct_uiTable;
pub extern fn uiTableAppendTextColumn(t: ?*uiTable, name: ?[*]const u8, textModelColumn: c_int, textEditableModelColumn: c_int, textParams: ?[*]uiTableTextColumnOptionalParams) void;
pub extern fn uiTableAppendImageColumn(t: ?*uiTable, name: ?[*]const u8, imageModelColumn: c_int) void;
pub extern fn uiTableAppendImageTextColumn(t: ?*uiTable, name: ?[*]const u8, imageModelColumn: c_int, textModelColumn: c_int, textEditableModelColumn: c_int, textParams: ?[*]uiTableTextColumnOptionalParams) void;
pub extern fn uiTableAppendCheckboxColumn(t: ?*uiTable, name: ?[*]const u8, checkboxModelColumn: c_int, checkboxEditableModelColumn: c_int) void;
pub extern fn uiTableAppendCheckboxTextColumn(t: ?*uiTable, name: ?[*]const u8, checkboxModelColumn: c_int, checkboxEditableModelColumn: c_int, textModelColumn: c_int, textEditableModelColumn: c_int, textParams: ?[*]uiTableTextColumnOptionalParams) void;
pub extern fn uiTableAppendProgressBarColumn(t: ?*uiTable, name: ?[*]const u8, progressModelColumn: c_int) void;
pub extern fn uiTableAppendButtonColumn(t: ?*uiTable, name: ?[*]const u8, buttonModelColumn: c_int, buttonClickableModelColumn: c_int) void;
pub extern fn uiNewTable(params: ?[*]uiTableParams) ?*uiTable;

// ForEach
pub const uiForEach = c_uint;
pub const uiForEachContinue = 0;
pub const uiForEachStop = 1;

// Internal
pub const ptrdiff_t = c_long;
pub const wchar_t = c_int;
pub const max_align_t = extern struct {
    __clang_max_align_nonce1: c_longlong,
    __clang_max_align_nonce2: c_longdouble,
};
pub const __u_char = u8;
pub const __u_short = c_ushort;
pub const __u_int = c_uint;
pub const __u_long = c_ulong;
pub const __int8_t = i8;
pub const __uint8_t = u8;
pub const __int16_t = c_short;
pub const __uint16_t = c_ushort;
pub const __int32_t = c_int;
pub const __uint32_t = c_uint;
pub const __int64_t = c_long;
pub const __uint64_t = c_ulong;
pub const __int_least8_t = __int8_t;
pub const __uint_least8_t = __uint8_t;
pub const __int_least16_t = __int16_t;
pub const __uint_least16_t = __uint16_t;
pub const __int_least32_t = __int32_t;
pub const __uint_least32_t = __uint32_t;
pub const __int_least64_t = __int64_t;
pub const __uint_least64_t = __uint64_t;
pub const __quad_t = c_long;
pub const __u_quad_t = c_ulong;
pub const __intmax_t = c_long;
pub const __uintmax_t = c_ulong;
pub const __dev_t = c_ulong;
pub const __uid_t = c_uint;
pub const __gid_t = c_uint;
pub const __ino_t = c_ulong;
pub const __ino64_t = c_ulong;
pub const __mode_t = c_uint;
pub const __nlink_t = c_ulong;
pub const __off_t = c_long;
pub const __off64_t = c_long;
pub const __pid_t = c_int;
pub const __fsid_t = extern struct {
    __val: [2]c_int,
};
pub const __clock_t = c_long;
pub const __rlim_t = c_ulong;
pub const __rlim64_t = c_ulong;
pub const __id_t = c_uint;
pub const __time_t = c_long;
pub const __useconds_t = c_uint;
pub const __suseconds_t = c_long;
pub const __daddr_t = c_int;
pub const __key_t = c_int;
pub const __clockid_t = c_int;
pub const __timer_t = ?*c_void;
pub const __blksize_t = c_long;
pub const __blkcnt_t = c_long;
pub const __blkcnt64_t = c_long;
pub const __fsblkcnt_t = c_ulong;
pub const __fsblkcnt64_t = c_ulong;
pub const __fsfilcnt_t = c_ulong;
pub const __fsfilcnt64_t = c_ulong;
pub const __fsword_t = c_long;
pub const __ssize_t = c_long;
pub const __syscall_slong_t = c_long;
pub const __syscall_ulong_t = c_ulong;
pub const __loff_t = __off64_t;
pub const __caddr_t = ?[*]u8;
pub const __intptr_t = c_long;
pub const __socklen_t = c_uint;
pub const __sig_atomic_t = c_int;
pub const int_least8_t = __int_least8_t;
pub const int_least16_t = __int_least16_t;
pub const int_least32_t = __int_least32_t;
pub const int_least64_t = __int_least64_t;
pub const uint_least8_t = __uint_least8_t;
pub const uint_least16_t = __uint_least16_t;
pub const uint_least32_t = __uint_least32_t;
pub const uint_least64_t = __uint_least64_t;
pub const int_fast8_t = i8;
pub const int_fast16_t = c_long;
pub const int_fast32_t = c_long;
pub const int_fast64_t = c_long;
pub const uint_fast8_t = u8;
pub const uint_fast16_t = c_ulong;
pub const uint_fast32_t = c_ulong;
pub const uint_fast64_t = c_ulong;
pub const intmax_t = __intmax_t;
pub const uintmax_t = __uintmax_t;
pub const __GCC_ATOMIC_TEST_AND_SET_TRUEVAL = 1;
pub const _STDC_PREDEF_H = 1;
pub const __FLT16_MAX_EXP__ = 15;
pub const __BIGGEST_ALIGNMENT__ = 16;
pub const __SIZEOF_FLOAT__ = 4;
pub const __INT64_FMTd__ = c"ld";
pub const __STDC_VERSION__ = c_long(201112);
pub const INT_FAST64_MAX = if (@typeId(@typeOf(9223372036854775807)) == @import("builtin").TypeId.Pointer) @ptrCast(__INT64_C, 9223372036854775807) else if (@typeId(@typeOf(9223372036854775807)) == @import("builtin").TypeId.Int) @intToPtr(__INT64_C, 9223372036854775807) else __INT64_C(9223372036854775807);
pub const __INT_LEAST32_FMTi__ = c"i";
pub const __INT_LEAST8_FMTi__ = c"hhi";
pub const __LDBL_EPSILON__ = 0.000000;
pub const __INT_LEAST32_FMTd__ = c"d";
pub const __STDC_UTF_32__ = 1;
pub const __SIG_ATOMIC_WIDTH__ = 32;
pub const __UINT_FAST64_FMTX__ = c"lX";
pub const __GCC_ATOMIC_LLONG_LOCK_FREE = 2;
pub const __clang_version__ = c"6.0.1 (tags/RELEASE_601/final)";
pub const __UINT_LEAST8_FMTo__ = c"hho";
pub const __SIZEOF_DOUBLE__ = 8;
pub const __INTMAX_FMTd__ = c"ld";
pub const uiTableModelColumnNeverEditable = -1;
pub const __CLANG_ATOMIC_CHAR_LOCK_FREE = 2;
pub const __INT_LEAST16_FMTi__ = c"hi";
pub const __GCC_ATOMIC_SHORT_LOCK_FREE = 2;
pub const UINTMAX_MAX = if (@typeId(@typeOf(18446744073709551615)) == @import("builtin").TypeId.Pointer) @ptrCast(__UINT64_C, 18446744073709551615) else if (@typeId(@typeOf(18446744073709551615)) == @import("builtin").TypeId.Int) @intToPtr(__UINT64_C, 18446744073709551615) else __UINT64_C(18446744073709551615);
pub const INT_LEAST64_MAX = if (@typeId(@typeOf(9223372036854775807)) == @import("builtin").TypeId.Pointer) @ptrCast(__INT64_C, 9223372036854775807) else if (@typeId(@typeOf(9223372036854775807)) == @import("builtin").TypeId.Int) @intToPtr(__INT64_C, 9223372036854775807) else __INT64_C(9223372036854775807);
pub const WINT_MIN = if (@typeId(@typeOf(u)) == @import("builtin").TypeId.Pointer) @ptrCast(0, u) else if (@typeId(@typeOf(u)) == @import("builtin").TypeId.Int) @intToPtr(0, u) else 0(u);
pub const __MMX__ = 1;
pub const INTPTR_MAX = c_long(9223372036854775807);
pub const __SIZE_FMTX__ = c"lX";
pub const __ID_T_TYPE = __U32_TYPE;
pub const __INO_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const _BITS_TYPES_H = 1;
pub const __FSBLKCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __ptr_t = [*]void;
pub const __WCHAR_WIDTH__ = 32;
pub const __STDC_IEC_559_COMPLEX__ = 1;
pub const __USE_MISC = 1;
pub const __FSBLKCNT64_T_TYPE = __UQUAD_TYPE;
pub const __PTRDIFF_FMTd__ = c"ld";
pub const __DBL_MIN_EXP__ = -1021;
pub const __FLT_EVAL_METHOD__ = 0;
pub const __SSE_MATH__ = 1;
pub const __USECONDS_T_TYPE = __U32_TYPE;
pub const __PID_T_TYPE = __S32_TYPE;
pub const __UINT_FAST8_FMTo__ = c"hho";
pub const __UINT_LEAST64_MAX__ = c_ulong(18446744073709551615);
pub const __UINT_LEAST64_FMTx__ = c"lx";
pub const __INT8_MAX__ = 127;
pub const __NLINK_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __DBL_HAS_DENORM__ = 1;
pub const __FLOAT128__ = 1;
pub const __HAVE_GENERIC_SELECTION = 1;
pub const __FLT16_HAS_QUIET_NAN__ = 1;
pub const __ATOMIC_RELAXED = 0;
pub const __DBL_DECIMAL_DIG__ = 17;
pub const __SIZEOF_SHORT__ = 2;
pub const __UINT16_FMTX__ = c"hX";
pub const __UINT_FAST16_MAX__ = 65535;
pub const __CLANG_ATOMIC_SHORT_LOCK_FREE = 2;
pub const __CONSTANT_CFSTRINGS__ = 1;
pub const __MODE_T_TYPE = __U32_TYPE;
pub const _SYS_CDEFS_H = 1;
pub const _ATFILE_SOURCE = 1;
pub const PTRDIFF_MAX = c_long(9223372036854775807);
pub const __RLIM_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __WINT_MAX__ = c_uint(4294967295);
pub const __LDBL_MAX_EXP__ = 16384;
pub const __USE_POSIX199309 = 1;
pub const __STDC_ISO_10646__ = c_long(201706);
pub const __NO_MATH_INLINES = 1;
pub const __WCHAR_TYPE__ = int;
pub const __BLKCNT64_T_TYPE = __SQUAD_TYPE;
pub const __LONG_MAX__ = c_long(9223372036854775807);
pub const __STDC_HOSTED__ = 1;
pub const __pic__ = 2;
pub const __WCHAR_MIN = if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Pointer) @ptrCast(-__WCHAR_MAX, -1) else if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Int) @intToPtr(-__WCHAR_MAX, -1) else (-__WCHAR_MAX)(-1);
pub const __INT_FAST16_FMTi__ = c"hi";
pub const __PTRDIFF_WIDTH__ = 64;
pub const __INT_LEAST32_TYPE__ = int;
pub const __SCHAR_MAX__ = 127;
pub const __USE_POSIX2 = 1;
pub const __LDBL_DENORM_MIN__ = 0.000000;
pub const __FLT16_MIN_EXP__ = -14;
pub const __USE_XOPEN2K = 1;
pub const __USE_FORTIFY_LEVEL = 0;
pub const __INT64_C_SUFFIX__ = L;
pub const __ELF__ = 1;
pub const __FSFILCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __LDBL_MANT_DIG__ = 64;
pub const __SSIZE_T_TYPE = __SWORD_TYPE;
pub const __USE_XOPEN2K8 = 1;
pub const __CLANG_ATOMIC_INT_LOCK_FREE = 2;
pub const __SIZEOF_PTRDIFF_T__ = 8;
pub const INT16_MIN = if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Pointer) @ptrCast(-32767, -1) else if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Int) @intToPtr(-32767, -1) else (-32767)(-1);
pub const __SIG_ATOMIC_MAX__ = 2147483647;
pub const __USE_ATFILE = 1;
pub const __UINT64_FMTX__ = c"lX";
pub const __UINT64_MAX__ = c_ulong(18446744073709551615);
pub const __DBL_MANT_DIG__ = 53;
pub const __FLT_DECIMAL_DIG__ = 9;
pub const __INT_LEAST32_MAX__ = 2147483647;
pub const __DBL_DIG__ = 15;
pub const __ATOMIC_ACQUIRE = 2;
pub const __OPENCL_MEMORY_SCOPE_WORK_GROUP = 1;
pub const __USE_ISOC95 = 1;
pub const __FLT16_HAS_DENORM__ = 1;
pub const __UID_T_TYPE = __U32_TYPE;
pub const __UINT_FAST16_FMTu__ = c"hu";
pub const __INTPTR_FMTi__ = c"li";
pub const _BITS_WCHAR_H = 1;
pub const __UINT_FAST8_FMTX__ = c"hhX";
pub const __LITTLE_ENDIAN__ = 1;
pub const __SSE__ = 1;
pub const __FLT_HAS_QUIET_NAN__ = 1;
pub const __SIZEOF_SIZE_T__ = 8;
pub const __UINT_LEAST16_FMTo__ = c"ho";
pub const __UINT8_FMTo__ = c"hho";
pub const UINT_LEAST64_MAX = if (@typeId(@typeOf(18446744073709551615)) == @import("builtin").TypeId.Pointer) @ptrCast(__UINT64_C, 18446744073709551615) else if (@typeId(@typeOf(18446744073709551615)) == @import("builtin").TypeId.Int) @intToPtr(__UINT64_C, 18446744073709551615) else __UINT64_C(18446744073709551615);
pub const __UINT_LEAST16_FMTx__ = c"hx";
pub const __CLANG_ATOMIC_WCHAR_T_LOCK_FREE = 2;
pub const __UINT_FAST16_FMTX__ = c"hX";
pub const __VERSION__ = c"4.2.1 Compatible Clang 6.0.1 (tags/RELEASE_601/final)";
pub const __UINT_FAST32_FMTx__ = c"x";
pub const __UINTPTR_MAX__ = c_ulong(18446744073709551615);
pub const __UINT_FAST8_FMTu__ = c"hhu";
pub const UINT16_MAX = 65535;
pub const __UINT_LEAST8_FMTu__ = c"hhu";
pub const __UINT_LEAST64_FMTo__ = c"lo";
pub const __UINT_LEAST8_MAX__ = 255;
pub const UINT8_MAX = 255;
pub const __SYSCALL_ULONG_TYPE = __ULONGWORD_TYPE;
pub const __warnattr = msg;
pub const __STD_TYPE = typedef;
pub const __SIZEOF_WCHAR_T__ = 4;
pub const __GLIBC_USE_DEPRECATED_GETS = 0;
pub const __LDBL_MAX__ = inf;
pub const __UINT16_MAX__ = 65535;
pub const _LP64 = 1;
pub const __CLOCK_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __x86_64 = 1;
pub const linux = 1;
pub const __SIZEOF_WINT_T__ = 4;
pub const __UINTMAX_FMTo__ = c"lo";
pub const __FLT_DIG__ = 6;
pub const __UINT_LEAST8_FMTX__ = c"hhX";
pub const __INT16_MAX__ = 32767;
pub const __WINT_UNSIGNED__ = 1;
pub const __FLT_MAX_10_EXP__ = 38;
pub const _FEATURES_H = 1;
pub const __UINTPTR_FMTX__ = c"lX";
pub const __UINT_LEAST16_FMTu__ = c"hu";
pub const __CLANG_ATOMIC_POINTER_LOCK_FREE = 2;
pub const SIG_ATOMIC_MAX = 2147483647;
pub const __WINT_WIDTH__ = 32;
pub const __SHRT_MAX__ = 32767;
pub const __GCC_ATOMIC_BOOL_LOCK_FREE = 2;
pub const __POINTER_WIDTH__ = 64;
pub const PTRDIFF_MIN = if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Pointer) @ptrCast(-c_long(9223372036854775807), -1) else if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Int) @intToPtr(-c_long(9223372036854775807), -1) else (-c_long(9223372036854775807))(-1);
pub const __PTRDIFF_MAX__ = c_long(9223372036854775807);
pub const __INT32_FMTd__ = c"d";
pub const __FLT16_DIG__ = 3;
pub const __DBL_MIN__ = 0.000000;
pub const __SIZEOF_LONG__ = 8;
pub const __S32_TYPE = int;
pub const __TIME_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __INTPTR_WIDTH__ = 64;
pub const __FLT16_MAX_10_EXP__ = 4;
pub const __INT_FAST32_TYPE__ = int;
pub const __NO_INLINE__ = 1;
pub const __UINT_FAST32_FMTX__ = c"X";
pub const _POSIX_SOURCE = 1;
pub const __gnu_linux__ = 1;
pub const __INT_FAST32_MAX__ = 2147483647;
pub const __UINTMAX_FMTu__ = c"lu";
pub const INT_FAST8_MAX = 127;
pub const __FLT_RADIX__ = 2;
pub const __GLIBC_MINOR__ = 28;
pub const _STDINT_H = 1;
pub const __FLT16_HAS_INFINITY__ = 1;
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 = 1;
pub const INT_FAST8_MIN = -128;
pub const __GCC_ATOMIC_INT_LOCK_FREE = 2;
pub const __OPENCL_MEMORY_SCOPE_ALL_SVM_DEVICES = 3;
pub const _BITS_STDINT_INTN_H = 1;
pub const __FLT16_DECIMAL_DIG__ = 5;
pub const __PRAGMA_REDEFINE_EXTNAME = 1;
pub const __INT_FAST8_FMTd__ = c"hhd";
pub const __KEY_T_TYPE = __S32_TYPE;
pub const __USE_POSIX199506 = 1;
pub const __INT32_TYPE__ = int;
pub const __CPU_MASK_TYPE = __SYSCALL_ULONG_TYPE;
pub const __UINTMAX_WIDTH__ = 64;
pub const __FLT_MIN__ = 0.000000;
pub const __INT64_FMTi__ = c"li";
pub const __UINT_FAST64_FMTu__ = c"lu";
pub const __INT8_FMTd__ = c"hhd";
pub const INT_LEAST16_MIN = if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Pointer) @ptrCast(-32767, -1) else if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Int) @intToPtr(-32767, -1) else (-32767)(-1);
pub const __INT_FAST16_TYPE__ = short;
pub const INT64_MAX = if (@typeId(@typeOf(9223372036854775807)) == @import("builtin").TypeId.Pointer) @ptrCast(__INT64_C, 9223372036854775807) else if (@typeId(@typeOf(9223372036854775807)) == @import("builtin").TypeId.Int) @intToPtr(__INT64_C, 9223372036854775807) else __INT64_C(9223372036854775807);
pub const __FLT_MAX_EXP__ = 128;
pub const __DBL_MAX_10_EXP__ = 308;
pub const __LDBL_MIN__ = 0.000000;
pub const __INT_FAST64_FMTi__ = c"li";
pub const __INT_LEAST8_FMTd__ = c"hhd";
pub const __CLANG_ATOMIC_LLONG_LOCK_FREE = 2;
pub const __FSFILCNT64_T_TYPE = __UQUAD_TYPE;
pub const __UINT_LEAST32_FMTX__ = c"X";
pub const __GID_T_TYPE = __U32_TYPE;
pub const __PIC__ = 2;
pub const __UINTMAX_MAX__ = c_ulong(18446744073709551615);
pub const __UINT_FAST16_FMTo__ = c"ho";
pub const _DEFAULT_SOURCE = 1;
pub const __FD_SETSIZE = 1024;
pub const __LDBL_DECIMAL_DIG__ = 21;
pub const __UINT_LEAST64_FMTX__ = c"lX";
pub const __clang_minor__ = 0;
pub const __LDBL_REDIR_DECL = name;
pub const INTMAX_MAX = if (@typeId(@typeOf(9223372036854775807)) == @import("builtin").TypeId.Pointer) @ptrCast(__INT64_C, 9223372036854775807) else if (@typeId(@typeOf(9223372036854775807)) == @import("builtin").TypeId.Int) @intToPtr(__INT64_C, 9223372036854775807) else __INT64_C(9223372036854775807);
pub const __OFF64_T_TYPE = __SQUAD_TYPE;
pub const __SIZEOF_FLOAT128__ = 16;
pub const __CLOCKID_T_TYPE = __S32_TYPE;
pub const __UINT_FAST64_FMTo__ = c"lo";
pub const __SIZE_FMTx__ = c"lx";
pub const INT_FAST16_MIN = if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Pointer) @ptrCast(-c_long(9223372036854775807), -1) else if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Int) @intToPtr(-c_long(9223372036854775807), -1) else (-c_long(9223372036854775807))(-1);
pub const __DBL_MAX__ = 179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878;
pub const __DBL_EPSILON__ = 0.000000;
pub const __UINT64_FMTx__ = c"lx";
pub const INT_FAST32_MIN = if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Pointer) @ptrCast(-c_long(9223372036854775807), -1) else if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Int) @intToPtr(-c_long(9223372036854775807), -1) else (-c_long(9223372036854775807))(-1);
pub const INT32_MAX = 2147483647;
pub const __BLKCNT_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __CHAR_BIT__ = 8;
pub const __INT16_FMTi__ = c"hi";
pub const __SLONG32_TYPE = int;
pub const _DEBUG = 1;
pub const __GNUC_MINOR__ = 2;
pub const INT_LEAST32_MIN = if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Pointer) @ptrCast(-2147483647, -1) else if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Int) @intToPtr(-2147483647, -1) else (-2147483647)(-1);
pub const INT32_MIN = if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Pointer) @ptrCast(-2147483647, -1) else if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Int) @intToPtr(-2147483647, -1) else (-2147483647)(-1);
pub const __restrict_arr = __restrict;
pub const __UINT_FAST32_MAX__ = c_uint(4294967295);
pub const __RLIM_T_MATCHES_RLIM64_T = 1;
pub const __UINT8_FMTX__ = c"hhX";
pub const __FLT_EPSILON__ = 0.000000;
pub const INT_FAST32_MAX = c_long(9223372036854775807);
pub const UINT_FAST8_MAX = 255;
pub const __UINTPTR_WIDTH__ = 64;
pub const __llvm__ = 1;
pub const __UINT_FAST64_MAX__ = c_ulong(18446744073709551615);
pub const __INT_FAST32_FMTi__ = c"i";
pub const INT16_MAX = 32767;
pub const __FLT_HAS_INFINITY__ = 1;
pub const __k8 = 1;
pub const __FSWORD_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __DADDR_T_TYPE = __S32_TYPE;
pub const __OFF_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __UINT8_FMTx__ = c"hhx";
pub const __INTMAX_C_SUFFIX__ = L;
pub const __ORDER_LITTLE_ENDIAN__ = 1234;
pub const __GCC_ATOMIC_CHAR16_T_LOCK_FREE = 2;
pub const __INT16_FMTd__ = c"hd";
pub const __UINT32_FMTX__ = c"X";
pub const __SUSECONDS_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 = 1;
pub const UINT_LEAST8_MAX = 255;
pub const __UINT32_C_SUFFIX__ = U;
pub const __INT32_MAX__ = 2147483647;
pub const __GCC_ATOMIC_CHAR_LOCK_FREE = 2;
pub const __INTMAX_WIDTH__ = 64;
pub const __INO64_T_TYPE = __UQUAD_TYPE;
pub const __CLANG_ATOMIC_BOOL_LOCK_FREE = 2;
pub const __USE_POSIX = 1;
pub const __SIZE_FMTo__ = c"lo";
pub const __DBL_HAS_QUIET_NAN__ = 1;
pub const __INT_FAST8_FMTi__ = c"hhi";
pub const __UINT_LEAST32_FMTo__ = c"o";
pub const __STDC_UTF_16__ = 1;
pub const __UINT_LEAST32_MAX__ = c_uint(4294967295);
pub const __ATOMIC_RELEASE = 3;
pub const __UINT_FAST16_FMTx__ = c"hx";
pub const __UINTMAX_C_SUFFIX__ = UL;
pub const __WCHAR_MAX = __WCHAR_MAX__;
pub const __FLT_MIN_EXP__ = -125;
pub const __SIZEOF_LONG_DOUBLE__ = 16;
pub const __UINT_LEAST64_FMTu__ = c"lu";
pub const __GCC_ATOMIC_LONG_LOCK_FREE = 2;
pub const __ORDER_PDP_ENDIAN__ = 3412;
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT = 0;
pub const __INT_FAST64_FMTd__ = c"ld";
pub const INT_LEAST8_MIN = -128;
pub const __CLANG_ATOMIC_LONG_LOCK_FREE = 2;
pub const __GXX_ABI_VERSION = 1002;
pub const __INT16_TYPE__ = short;
pub const __SSE2_MATH__ = 1;
pub const INTPTR_MIN = if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Pointer) @ptrCast(-c_long(9223372036854775807), -1) else if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Int) @intToPtr(-c_long(9223372036854775807), -1) else (-c_long(9223372036854775807))(-1);
pub const __FLT_MANT_DIG__ = 24;
pub const UINT_LEAST16_MAX = 65535;
pub const uiTableModelColumnAlwaysEditable = -2;
pub const __GLIBC_USE_IEC_60559_TYPES_EXT = 0;
pub const UINT_LEAST32_MAX = c_uint(4294967295);
pub const __UINT_FAST64_FMTx__ = c"lx";
pub const __STDC__ = 1;
pub const __INT_FAST8_MAX__ = 127;
pub const __INTPTR_FMTd__ = c"ld";
pub const __GNUC_PATCHLEVEL__ = 1;
pub const __SIZE_WIDTH__ = 64;
pub const __UINT_LEAST8_FMTx__ = c"hhx";
pub const __INT_LEAST64_FMTi__ = c"li";
pub const __STDC_IEC_559__ = 1;
pub const __INT_FAST16_MAX__ = 32767;
pub const __USE_ISOC99 = 1;
pub const __INTPTR_MAX__ = c_long(9223372036854775807);
pub const __CLANG_ATOMIC_CHAR16_T_LOCK_FREE = 2;
pub const __UINT64_FMTu__ = c"lu";
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __SSE2__ = 1;
pub const __INT_MAX__ = 2147483647;
pub const __BLKSIZE_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __INTMAX_FMTi__ = c"li";
pub const __DBL_DENORM_MIN__ = 0.000000;
pub const __clang_major__ = 6;
pub const __FLT16_MANT_DIG__ = 11;
pub const __GNUC__ = 4;
pub const __UINT32_MAX__ = c_uint(4294967295);
pub const UINTPTR_MAX = c_ulong(18446744073709551615);
pub const _POSIX_C_SOURCE = c_long(200809);
pub const __FLT_DENORM_MIN__ = 0.000000;
pub const __DBL_MAX_EXP__ = 1024;
pub const __INT8_FMTi__ = c"hhi";
pub const __UINT_LEAST16_MAX__ = 65535;
pub const SIG_ATOMIC_MIN = if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Pointer) @ptrCast(-2147483647, -1) else if (@typeId(@typeOf(-1)) == @import("builtin").TypeId.Int) @intToPtr(-2147483647, -1) else (-2147483647)(-1);
pub const __LDBL_HAS_DENORM__ = 1;
pub const __FLT16_MIN_10_EXP__ = -13;
pub const __LDBL_HAS_QUIET_NAN__ = 1;
pub const __UINT_FAST8_MAX__ = 255;
pub const __DBL_MIN_10_EXP__ = -307;
pub const __GLIBC_USE_LIB_EXT2 = 0;
pub const uiDrawDefaultMiterLimit = 10.000000;
pub const __UINT8_FMTu__ = c"hhu";
pub const __OFF_T_MATCHES_OFF64_T = 1;
pub const WINT_MAX = c_uint(4294967295);
pub const __RLIM64_T_TYPE = __UQUAD_TYPE;
pub const UINT_FAST16_MAX = c_ulong(18446744073709551615);
pub const __INT_FAST64_MAX__ = c_long(9223372036854775807);
pub const __UINT16_FMTu__ = c"hu";
pub const __ATOMIC_SEQ_CST = 5;
pub const __SIZE_FMTu__ = c"lu";
pub const __LDBL_MIN_EXP__ = -16381;
pub const __UINT_FAST32_FMTu__ = c"u";
pub const __pie__ = 2;
pub const SIZE_MAX = c_ulong(18446744073709551615);
pub const __SSP_STRONG__ = 2;
pub const __clang_patchlevel__ = 1;
pub const __SIZEOF_LONG_LONG__ = 8;
pub const __GNUC_STDC_INLINE__ = 1;
pub const __FXSR__ = 1;
pub const uiPi = 3.141593;
pub const __UINT8_MAX__ = 255;
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 = 1;
pub const __UINT32_FMTx__ = c"x";
pub const __UINT16_FMTo__ = c"ho";
pub const __OPENCL_MEMORY_SCOPE_DEVICE = 2;
pub const INT_LEAST8_MAX = 127;
pub const __UINT32_FMTu__ = c"u";
pub const _UI_EXTERN = @"extern";
pub const __SIZEOF_POINTER__ = 8;
pub const __TIMER_T_TYPE = [*]void;
pub const __SIZE_MAX__ = c_ulong(18446744073709551615);
pub const __unix = 1;
pub const __GLIBC_USE_IEC_60559_BFP_EXT = 0;
pub const __INT_FAST16_FMTd__ = c"hd";
pub const unix = 1;
pub const __UINT_LEAST32_FMTu__ = c"u";
pub const __FLT_MAX__ = 340282346999999984391321947108527833088.000000;
pub const __USE_ISOC11 = 1;
pub const __GCC_ATOMIC_WCHAR_T_LOCK_FREE = 2;
pub const __k8__ = 1;
pub const __ATOMIC_CONSUME = 1;
pub const __tune_k8__ = 1;
pub const __unix__ = 1;
pub const UINT32_MAX = c_uint(4294967295);
pub const __x86_64__ = 1;
pub const __LDBL_HAS_INFINITY__ = 1;
pub const __WORDSIZE_TIME64_COMPAT32 = 1;
pub const __UINTMAX_FMTx__ = c"lx";
pub const __UINT64_C_SUFFIX__ = UL;
pub const __GNU_LIBRARY__ = 6;
pub const __FLT_MIN_10_EXP__ = -37;
pub const __INT_LEAST16_MAX__ = 32767;
pub const __UINT32_FMTo__ = c"o";
pub const __UINTPTR_FMTo__ = c"lo";
pub const __INT_LEAST16_FMTd__ = c"hd";
pub const __UINTPTR_FMTx__ = c"lx";
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = 1;
pub const __INT_LEAST64_FMTd__ = c"ld";
pub const UINT64_MAX = if (@typeId(@typeOf(18446744073709551615)) == @import("builtin").TypeId.Pointer) @ptrCast(__UINT64_C, 18446744073709551615) else if (@typeId(@typeOf(18446744073709551615)) == @import("builtin").TypeId.Int) @intToPtr(__UINT64_C, 18446744073709551615) else __UINT64_C(18446744073709551615);
pub const __INT_LEAST16_TYPE__ = short;
pub const __attribute_alloc_size__ = params;
pub const __ORDER_BIG_ENDIAN__ = 4321;
pub const __LDBL_MIN_10_EXP__ = -4931;
pub const __INT_LEAST8_MAX__ = 127;
pub const __SIZEOF_INT__ = 4;
pub const __USE_POSIX_IMPLICITLY = 1;
pub const __GCC_ATOMIC_POINTER_LOCK_FREE = 2;
pub const INT8_MIN = -128;
pub const WCHAR_MAX = __WCHAR_MAX;
pub const __amd64 = 1;
pub const INT8_MAX = 127;
pub const __OBJC_BOOL_IS_BOOL = 0;
pub const __LDBL_MAX_10_EXP__ = 4932;
pub const __SIZEOF_INT128__ = 16;
pub const __UINT_FAST8_FMTx__ = c"hhx";
pub const UINT_FAST32_MAX = c_ulong(18446744073709551615);
pub const __PIE__ = 2;
pub const __glibc_c99_flexarr_available = 1;
pub const __linux = 1;
pub const __UINT16_FMTx__ = c"hx";
pub const __UINTPTR_FMTu__ = c"lu";
pub const __UINT_LEAST16_FMTX__ = c"hX";
pub const WCHAR_MIN = __WCHAR_MIN;
pub const __amd64__ = 1;
pub const __UINT_FAST32_FMTo__ = c"o";
pub const __linux__ = 1;
pub const __clang__ = 1;
pub const __LP64__ = 1;
pub const INT_FAST16_MAX = c_long(9223372036854775807);
pub const __SYSCALL_WORDSIZE = 64;
pub const __PTRDIFF_FMTi__ = c"li";
pub const __LDBL_DIG__ = 18;
pub const __GCC_ATOMIC_CHAR32_T_LOCK_FREE = 2;
pub const _BITS_TYPESIZES_H = 1;
pub const __UINT64_FMTo__ = c"lo";
pub const __INT_FAST32_FMTd__ = c"d";
pub const __ATOMIC_ACQ_REL = 4;
pub const __LONG_LONG_MAX__ = c_longlong(9223372036854775807);
pub const __OPENCL_MEMORY_SCOPE_SUB_GROUP = 4;
pub const __INO_T_MATCHES_INO64_T = 1;
pub const INT_LEAST16_MAX = 32767;
pub const __GLIBC__ = 2;
pub const UINT_FAST64_MAX = if (@typeId(@typeOf(18446744073709551615)) == @import("builtin").TypeId.Pointer) @ptrCast(__UINT64_C, 18446744073709551615) else if (@typeId(@typeOf(18446744073709551615)) == @import("builtin").TypeId.Int) @intToPtr(__UINT64_C, 18446744073709551615) else __UINT64_C(18446744073709551615);
pub const INT_LEAST32_MAX = 2147483647;
pub const __INTMAX_MAX__ = c_long(9223372036854775807);
pub const __UINT_LEAST32_FMTx__ = c"x";
pub const __WORDSIZE = 64;
pub const __WCHAR_MAX__ = 2147483647;
pub const __INT64_MAX__ = c_long(9223372036854775807);
pub const __CLANG_ATOMIC_CHAR32_T_LOCK_FREE = 2;
pub const __INT_LEAST64_MAX__ = c_long(9223372036854775807);
pub const _BITS_STDINT_UINTN_H = 1;
pub const __UINTMAX_FMTX__ = c"lX";
pub const __OPENCL_MEMORY_SCOPE_WORK_ITEM = 0;
pub const __FLT_HAS_DENORM__ = 1;
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __SYSCALL_SLONG_TYPE = __SLONGWORD_TYPE;
pub const __DEV_T_TYPE = __UQUAD_TYPE;
pub const __INT32_FMTi__ = c"i";
pub const __DBL_HAS_INFINITY__ = 1;
pub const __FINITE_MATH_ONLY__ = 0;
pub const tm = struct_tm;
