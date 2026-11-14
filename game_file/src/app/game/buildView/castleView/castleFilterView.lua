_ENV = nil
local _ENV, (nil).nodeSize, _defaultParam = cc.size(450, 85), cc.size(450, 85), nil
_ENV = 85
cc.size(450, 85)[gSkinFilterType.ALL], (85).title = 85, "common_text_635"
_ENV = 85
cc.size(450, 85)[gSkinFilterType.HOLIDAY], (85).title = 85, "recharge_label_011"
_ENV = 85
cc.size(450, 85)[gSkinFilterType.LIMIT], (85).title = 85, "complete_text_02"
_ENV = 85
cc.size(450, 85)[gSkinFilterType.SUPREME], (85).title = 85, "begging_text_02"
_ENV = 85
cc.size(450, 85)[gSkinFilterType.NORMAL], (85).title = 85, "common_text_2697"
local skinFilterTypeConfig = cc.size(450, 85)
local castleSkinRead = include("castleSkinRead")
local castleFilterView = class("castleFilterView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("castleFilterView")
	end
	if type(target) == "string" then
		return SoraDCreateTouchPanel(target)
	end
	return target
end)
function castleFilterView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("gem_btn_01"))
	self.Center_Bg = SoraDGetChildByName(self, "Center_Node")
	self.img_frame = SoraDGetChildByName(self, "img_frame")
	self.text_title_bg = SoraDGetChildByName(self, "text_title_bg")
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.btn_go = SoraDGetChildByName(self, "btn_go")
	self.frame_lace_top = SoraDGetChildByName(self, "frame_lace_top")
	self.frame_lace_bottom = SoraDGetChildByName(self, "frame_lace_bottom")
	self.panel_single = SoraDGetChildByName(self, "panel_single")
	self.btn_select = SoraDGetChildByName(self, "btn_select")
	self.text_desc = SoraDGetChildByName(self, "text_desc")
	self.img_selected = SoraDGetChildByName(self, "img_selected")
	self.btn_go:addTouchEventListener(handler(self, self.onClick_btn_go))
	self.btn_select:addTouchEventListener(handler(self, self.onClick_btn_select))
	self.btn_select:setTouchEnabled(false)
	self.btn_go:setTitleText(i18n("common_text_204"))
	self.panel_single:setTouchEnabled(true)
	self.panel_single:addTouchEventListener(handler(self, self.onClick_panel))
end
function castleFilterView:init(data)
	self.data = data
	self.selHandler = self.data.selHandler
	self.selFilterType = self.data.curFilterType or self.data.filterArray[1]
	self.oriFilterType = self.selFilterType
	local selNums = #self.data.filterArray
	self.tbSelPanels, _ENV = nil, nil
	table.insert(self.tbSelPanels, self.panel_single)
	for i = 2, selNums do
		local panel = self.panel_single:clone()
		panel:addTo(self.Center_Bg)
		table.insert(self.tbSelPanels, panel)
	end
	for i = 1, selNums do
		self:initPanel(self.tbSelPanels[i], i)
		self.tbSelPanels[i]:setPositionY(150 - (i - 1) * _defaultParam.nodeSize.height)
		if self.selFilterType == self.data.filterArray[i] then
			local panel = self.tbSelPanels[i]
			local btn_select = panel:getChildByName("btn_select")
			local img_select = btn_select:getParent():getChildByName("img_selected")
			if img_select then
				img_select:setVisible(true)
			end
			self.curSel = panel
		end
	end
end
function castleFilterView:initPanel(panel, i)
	local text_desc = panel:getChildByName("text_desc")
	local btn_select = panel:getChildByName("btn_select")
	local iconQuality = panel:getChildByName("icon_quality")
	local itemBg = panel:getChildByName("Item_Bg")
	local filterType = self.data.filterArray[i]
	local filterTypeCfg = skinFilterTypeConfig[filterType]
	text_desc:setString(i18n(filterTypeCfg.title))
	panel:setTag(filterType)
	btn_select:setTag(filterType)
	local skinQualityCfg = castleSkinRead.getSkinQualityCfg(filterType)
	if skinQualityCfg then
		iconQuality:setSpriteFrame(SoraDFIsRA() and skinQualityCfg.ar or skinQualityCfg.en)
		iconQuality:setVisible(true)
	else
		iconQuality:setVisible(false)
	end
	local isShowBg = false
	if math.fmod(i, 2) == 1 then
		isShowBg = true
	end
	itemBg:setVisible(isShowBg)
end
function castleFilterView:onMessageListener()
end
function castleFilterView:onClick_btn_go(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("self.oriFilterType ,self.selFilterType = ", self.oriFilterType, self.selFilterType)
		if self.oriFilterType ~= self.selFilterType then
			print("选中了类型：", self.selFilterType)
			if self.selHandler then
				self.selHandler(self.selFilterType)
			end
		end
		self:closePanel()
	end
end
function castleFilterView:onClick_btn_select(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
	end
end
function castleFilterView:onClick_panel(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		if self.curSel == sender then
			return
		end
		if self.curSel then
			local btn_select_cur = self.curSel:getChildByName("btn_select")
			local img_select_cur = btn_select_cur:getParent():getChildByName("img_selected")
			if img_select_cur then
				img_select_cur:setVisible(false)
			end
		end
		local btn_select = sender:getChildByName("btn_select")
		local img_select = btn_select:getParent():getChildByName("img_selected")
		if img_select then
			img_select:setVisible(true)
		end
		self.curSel = sender
		self.selFilterType = sender:getTag()
	end
end
function castleFilterView:enableBtn(btn, isEnable)
	btn:setTouchEnabled(isEnable)
	btn:getVirtualRenderer():setState(isEnable and 0 or 1)
end
return castleFilterView
