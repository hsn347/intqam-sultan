local mainUIDef = include("mainUIDef")
local CommonFramTitle = class("commonFramTitle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonFramTitle")
	end
	return target
end)
function CommonFramTitle:ctor(target, parent)
	if parent then
		parent:bindBtnClose()
	end
	self.bg = SoraDGetChildByName(self, "Sprite_title")
	self.title = SoraDGetChildByName(self, "Text_title")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest")
	self.title:setVisible(false)
	self.btnMyHelp = SoraDGetChildByName(self, "Button_myHelp")
	self.btnMyHelp:setVisible(false)
	self.Node_style_bg = SoraDGetChildByName(self, "Node_style_bg")
	self.Node_6thLace = SoraDGetChildByName(self, "Node_6thLace")
	self.Node_6thLace:setVisible(false)
	self:initStyle()
end
function CommonFramTitle:initStyle(style)
	_ENV = nil
	_ENV = nil
	;(nil)[gMainUIStype.EASTER], (nil).bg = nil, "Node_fram_style_easter"
	_ENV = nil
	;(nil)[gMainUIStype.HALLOWEEN], (nil).bg = nil, "Node_fram_style_halloween"
	_ENV = nil
	;(nil)[gMainUIStype.CHRITMAS], (nil).bg = nil, "Node_fram_style_chritmas"
	_ENV = nil
	;(nil)[gMainUIStype.QUICKSAND], (nil).bg = nil, "Node_fram_style_ztsz"
	;(nil)[gMainUIStype.ROSNORMAL], _ENV = nil, nil
	local param
	local _style = style or GLOBAL_MAINUI_STYLE or gMainUIStype.QUICKSAND
	local cfg = param[_style]
	if cfg.bg then
		local bgNode = SoraDCreatAnimation(cfg.bg, nil, cfg.isLoop or false)
		bgNode:addTo(self.Node_style_bg)
		if _style == gMainUIStype.EASTER then
			local spine_dingkuang1 = sp.SkeletonAnimation:create("spine/dingkuang01.skel", "spine/dingkuang01.atlas", 1.0)
			spine_dingkuang1:setAnimation(0, "animation", true)
			spine_dingkuang1:setPosition(cc.p(SoraDFPosX(480, 0), -67))
			spine_dingkuang1:addTo(bgNode, 2)
			local spine_dingkuang2 = sp.SkeletonAnimation:create("spine/dingkuang02.skel", "spine/dingkuang02.atlas", 1.0)
			spine_dingkuang2:setAnimation(0, "animation", true)
			spine_dingkuang2:setPosition(cc.p(SoraDFPosX(400, 0), -67))
			spine_dingkuang2:addTo(bgNode, 2)
		end
	end
end
function CommonFramTitle:setStyle(style)
	self:initStyle(style)
end
function CommonFramTitle:setTitle(title)
	if self.title then
		self.title:setVisible(true)
		self.title:setString(title)
		if self.title:getContentSize().width >= 460 then
			self.title:setScale(460 / self.title:getContentSize().width)
		end
	end
	self:addTextEffect()
end
function CommonFramTitle:setTitleWidthHeight(size)
	if self.title then
		SoraDSetTextWidthHeight(self.title, size)
	end
end
function CommonFramTitle:setQuestBtnVisible(bool)
	self.btnQuest:setVisible(bool)
end
function CommonFramTitle:setTitleSize(size)
	if size == nil then
		size = cc.size(465, 40)
	end
	SoraDSetTextWidthHeight(self.title, size)
end
function CommonFramTitle:returnTitle()
	return self.title
end
function CommonFramTitle:setTitleColor(color)
	if self.title then
		self.title:setColor(color)
	end
end
function CommonFramTitle:setFontSize(size)
	if size then
		self.title:setFontSize(size)
	end
end
function CommonFramTitle:setTextClickCallBack(handl)
	if handl then
		self.title:setTouchEnabled(true)
		self.title:addTouchEventListener(handl)
	end
end
function CommonFramTitle:setTitleBgClickCallBack(handl)
	if handl then
		self.bg:setTouchEnabled(true)
		self.bg:addTouchEventListener(handl)
	end
end
function CommonFramTitle:setBtnHelpClickCallBack(handl)
	if handl then
		self.btnMyHelp:setVisible(true)
		self.btnMyHelp:addTouchEventListener(handl)
	end
end
function CommonFramTitle:setBackgroundVisible(isVisibled)
	self.bg:setVisible(isVisibled)
end
function CommonFramTitle:set6thLaceVisible(ret)
	self.Node_6thLace:setVisible(ret)
end
function CommonFramTitle:addTextEffect(fromColor, toColor)
	local _labelRenderer = self.title:getVirtualRenderer()
	if _labelRenderer.enableGradient then
		_labelRenderer:enableGradient(fromColor or cc.c3b(230, 219, 197), toColor or cc.c3b(178, 140, 68))
	end
	_labelRenderer:enableShadow(cc.c3b(15, 6, 2), cc.size(2, -2))
end
return CommonFramTitle
