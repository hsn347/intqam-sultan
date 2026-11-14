local atlantisWarFAQ = class("atlantisWarFAQ", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisWarFAQ")
	end
	return target
end)
local AEC = require_data("atlantiswar_explain_config").data
function atlantisWarFAQ:ctor()
	self.typeConfig, _ENV = nil, nil
	local _ENV, configs
	for i, v in ipairs(AEC) do
		if not configs[v.type] then
			_ENV = configs[v.type]
		end
		configs[v.type] = configs[v.type]
		table.insert(configs[v.type], v.index)
	end
	self.explain_config = configs
	self:initWidget()
end
function atlantisWarFAQ:initWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("atlantiswar_text_0331"))
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.scroll = SoraDGetChildByName(self, "ScrollView_FAQ")
	self.Node_content = SoraDGetChildByName(self, "Node_content")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	local Text_des = SoraDGetChildByName(self.Node_single, "Text_des")
	Text_des:setTextHorizontalAlignment(SoraDFLabelR())
	self.Node_icon = SoraDGetChildByName(self, "Node_icon")
	local bgSize = self.ccs_bg:getSize()
	local bgH = bgSize.height * display.height / 960
	self.ccs_bg:setSize(cc.size(bgSize.width, bgH))
	self.ccs_bg:setPositionY(-bgH / 2)
	self.Node_content:setPositionY((bgH - bgSize.height) / 2)
	self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, bgH - 120))
	self:initTabBtn()
end
function atlantisWarFAQ:initTabBtn(...)
	self.ccs_tab:setContentSize(cc.size(536, 56))
	self.ccs_tab:setNewStyle()
	self.ccs_tab:hideLineAndBg()
	_ENV, _ENV = self.ccs_tab, self.ccs_tab.hideLineAndBg
	self.ccs_tab.title = i18n("atlantiswar_text_0302")
	_ENV, self.ccs_tab.hideLineAndBg[1], self.ccs_tab.handle = self.ccs_tab, self.ccs_tab, handler(self, self.btnTabClick)
	self.ccs_tab.title = i18n("atlantiswar_text_0303")
	_ENV, self.ccs_tab.hideLineAndBg[2], self.ccs_tab.handle = self.ccs_tab, self.ccs_tab, handler(self, self.btnTabClick)
	self.ccs_tab.title = i18n("atlantiswar_text_0304")
	self.ccs_tab.hideLineAndBg[3], self.ccs_tab.handle = self.ccs_tab, handler(self, self.btnTabClick)
	local tabsetArray = self.ccs_tab.hideLineAndBg
	_ENV = self
	self.tabNum = #tabsetArray
	self.defaultClick = 1
	self.tabsetArray = tabsetArray
	self.ccs_tab:initView(self)
end
function atlantisWarFAQ:btnTabClick(tag, name)
	print("==atlantisWarFAQ:btnTabClick==", tag)
	if self.curType then
		local typeConfig = self.typeConfig[self.curType]
		if typeConfig and typeConfig.point then
			typeConfig.point:setVisible(false)
		end
	end
	self.curType = tag
	self:initPageView()
	self.scroll:jumpToTop()
end
function atlantisWarFAQ:initPageView(...)
	if not self.typeConfig[self.curType] then
		_ENV = self.typeConfig[self.curType]
		self.typeConfig[self.curType].point = nil
		self.typeConfig[self.curType].scrollH = nil
	end
	self.typeConfig[self.curType] = self.typeConfig[self.curType]
	local typeConfig = self.typeConfig[self.curType]
	local point = typeConfig.point
	if not point then
		local node = display.newNode()
		node:addTo(self.scroll)
		typeConfig.point = node
		local totalH = 0
		local _ENV, singleList = node, node
		local height1 = 36
		local height2 = 10
		local height3 = 20
		local height4 = 200
		local widthDes = 502
		local singleH = height1 + height2 + height3
		local config = self.explain_config[self.curType]
		for i, v in ipairs(config) do
			local single = self.Node_single:clone()
			single:addTo(node)
			local data = AEC[v]
			SoraDGetAllChildFromWidget(single, single)
			single.Text_title:setString(i18n(data.title))
			single.Text_des:setString(i18n(data.des))
			local height = SoraDGetAutoHeightLabelNew(single.Text_des, widthDes) + singleH
			if data.icon and data.icon ~= "" then
				local icon = self.Node_icon:clone()
				icon:addTo(single, -1)
				icon:setPosition(0, -height1)
				single.Text_des:setPositionY(single.Text_des:getPositionY() - height4)
				height = height + height4
				local Sprite_icon = SoraDGetChildByName(icon, "Sprite_icon")
				Sprite_icon:setSpriteFrame(data.icon)
			end
			totalH = totalH + height
			_ENV = Sprite_icon.setSpriteFrame
			Sprite_icon.setSpriteFrame.point = single
			Sprite_icon.setSpriteFrame.height = height
			table.insert(singleList, Sprite_icon.setSpriteFrame)
		end
		totalH = totalH - height3
		local sSize = self.scroll:getContentSize()
		local scrollH = math.max(sSize.height, totalH)
		self.scroll:setInnerContainerSize(cc.size(sSize.width, scrollH))
		typeConfig.scrollH = scrollH
		for i, v in ipairs(singleList) do
			v.point:setPosition(sSize.width / 2, scrollH)
			scrollH = scrollH - v.height
		end
	else
		point:setVisible(true)
		local sSize = self.scroll:getContentSize()
		self.scroll:setInnerContainerSize(cc.size(sSize.width, typeConfig.scrollH))
	end
end
return atlantisWarFAQ
