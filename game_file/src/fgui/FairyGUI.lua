FairyGUI = CS.FairyGUI
fgui = FairyGUI
requireLocal(".GObjectEx")
requireLocal(".GComponentEx")
requireLocal(".GButtonEx")
requireLocal(".GProgressBarEx")
requireLocal(".GLoaderEx")
requireLocal(".ScrollPaneEx")
requireLocal(".GTextFieldEx")
requireLocal(".GLabelEx")
requireLocal(".GMovieClipEx")
requireLocal(".GListEx")
requireLocal(".extension2.UIPackageEx2")
requireLocal(".extension2.GObjectEx2")
requireLocal(".extension2.GComponentEx2")
requireLocal(".extension2.GButtonEx2")
requireLocal(".extension2.GProgressBarEx2")
requireLocal(".extension2.GLoaderEx2")
requireLocal(".extension2.GTextInputEx2")
requireLocal(".extension2.GTextFieldEx2")
requireLocal(".extension2.GSliderEx2")
requireLocal(".extension2.TransitionEx2")
requireLocal(".extension2.ScrollPaneEx2")
requireLocal(".extension2.GGraphEx2")
requireLocal(".extension2.GLabelEx2")
requireLocal(".extension2.GLoaderEx2")
requireLocal(".extension2.GLoader3DEx2")
requireLocal(".extension2.PageViewEx2")
requireLocal(".extension2.NTextureEx2")
requireLocal(".extension2.GComboBoxEx2")
require("fgui.base.uiManager")
require("fgui.fguiEnum")
require("fgui.fguiHelper")
function fgui.register_extension(url, extension)
	CS.FairyGUI.UIObjectFactory.SetExtension(url, typeof(extension.base), extension.Extend)
end
function fgui.extension_class(clsName, base, baseCls, ...)
	local otherBaseCls
	if type(clsName) ~= "string" then
		otherBaseCls = baseCls
		baseCls = base
		base = clsName
		clsName = "extension_class"
	end
	local o = otherBaseCls == nil and class(clsName, baseCls, ...) or class(clsName, baseCls, otherBaseCls, ...)
	o.__index = o
	o.base = base or fgui.GComponent
	function o.Extend(ins)
		local _ENV, t
		setmetatable(t, o)
		t._data, _ENV = setmetatable, setmetatable
		t.__ins = ins
		xlua.setpeer(ins, t)
		return t
	end
	return o
end
require("midware.baseComponent.BaseCheckBox")
require("midware.baseComponent.BaseComponent")
require("midware.baseComponent.BaseImageView")
require("midware.baseComponent.BaseProgressBar")
require("midware.baseComponent.CCScrollView")
require("midware.baseComponent.UIScrollView")
require("midware.baseComponent.BaseSlider")
require("midware.baseComponent.BaseSprite")
require("midware.baseComponent.BaseText")
require("midware.baseComponent.BaseRichText")
require("midware.baseComponent.BaseInput")
CS.FairyGUI.GRoot.inst:SetContentScaleFactor(640, 1136, CS.FairyGUI.UIContentScaler.ScreenMatchMode.MatchWidth)
local packageManager = require("fgui.base.packageManager")
packageManager:addCommonPackages()
