local cityBuildViewDef = include("cityBuildViewDef")
local itemDesRead = include("itemDesRead")
local mailFunctions = include("mailFunctions")
local mailItemBuildBox = class("mailItemBuildBox", function(target)
	if target == nil then
		local view = include("ccsView")
		return view.new(getCCSPath("mailItemBuildBox"))
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function mailItemBuildBox:ctor()
	self:setCascadeOpacityEnabled(true)
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	if self.layout_content then
		self.layout_content:setSwallowTouches(false)
	end
	self.img_build = SoraDGetChildByName(self, "img_build")
	self.text_name = SoraDGetChildByName(self, "text_name")
	self.text_bg = SoraDGetChildByName(self, "text_bg")
	self.sprite_warLv = SoraDGetChildByName(self, "Sprite_warLv")
	local itemSize = self.layout_content:getContentSize()
	self.itemWidth = itemSize.width
	self.itemHeight = itemSize.height
	self:setAnchorPoint(cc.p(0, 0))
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailItemBuildBox:initWithData(data)
	local itemId = data.id
	local lv = data.lv
	local viewModel = cityBuildViewDef.getViewModelByLv(lv, cityBuildViewDef.tblViewModelTurret)
	local imgName = string.format("jianta_lv%d.png", viewModel)
	self.img_build:loadTexture(imgName, ccui.TextureResType.plistType)
	local buildName = i18n("buildDes_name_103")
	local isShowWarLv, textLv = SoraDGetBuildWarLv(lv)
	cityBuildViewDef = nil
	;(nil).lv = textLv
	local strName = buildName .. " " .. i18n("common_text_101", nil)
	if isShowWarLv and self.sprite_warLv then
		self.sprite_warLv:setVisible(true)
	end
	self.text_name:setString(strName)
	local autoHeight = SoraDGetAutoHeightLabel(self.text_name, 100)
	local bgSize = cc.size(100, autoHeight + 14)
	self.text_name:setAnchorPoint(cc.p(0.5, 0))
	self.text_name:setPosition(cc.p(60, 14))
	self.text_name:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)
	self.text_bg:setContentSize(bgSize)
	self.text_bg:setAnchorPoint(cc.p(0, 0))
	self.text_bg:setPosition(cc.p(11, 8))
end
function mailItemBuildBox:getItemWidth()
	return self.itemWidth
end
function mailItemBuildBox:getItemHeight()
	return self.itemHeight
end
return mailItemBuildBox
