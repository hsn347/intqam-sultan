local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local combinationItem = class("combinationItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("combinationItem")
	end
	return target
end)
function combinationItem:ctor()
	self.nodeList, combinationCtrl = nil, nil
	self.slotList = combinationCtrl:getBaseCombinationSlotList()
	self:initWidget()
end
function combinationItem:initWidget()
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Button_config = SoraDGetChildByName(self, "Button_config")
	self.Button_config:setSwallowTouches(false)
	self.Button_config:setTitleText(i18n("privilege_text_126"))
	SoraDAutoSizeButtonText(self.Button_config)
	self.Button_config = SoraDCreatePanelByCloneNode(self.Button_config, "commonBtnInstance")
	self.Button_config:setHandle(handler(self, self.onConfigClick))
	self.Button_use = SoraDGetChildByName(self, "Button_use")
	self.Button_use:setSwallowTouches(false)
	self.Button_use:setTitleText(i18n("common_text_314"))
	SoraDAutoSizeButtonText(self.Button_use)
	self.Button_use = SoraDCreatePanelByCloneNode(self.Button_use, "commonBtnInstance")
	self.Button_use:setHandle(handler(self, self.onUseClick))
	self.Text_inUse = SoraDGetChildByName(self, "Text_inUse")
	self.Text_inUse:setString(i18n("privilege_text_130"))
	self.Node_c = SoraDGetChildByName(self, "Node_c")
	local startY = self.Node_c:getPositionY()
	for i = 1, #self.slotList do
		local node = i == 1 and self.Node_c or self.Node_c:clone()
		if 1 < i then
			node:addTo(self.Node_c:getParent())
		end
		node:setPositionY(startY - 60 * (i - 1))
		table.insert(self.nodeList, node)
	end
	for i, node in ipairs(self.nodeList) do
		SoraDGetChildByName(node, "Sprite_icon"):setSpriteFrame(self.slotList[i].iconFrame)
		node.Text_cname = SoraDGetChildByName(node, "Text_cname")
		node.Text_cname:setString(i18n("common_text_480"))
	end
end
function combinationItem:initData(index)
	self.index = index
	local ctype = combinationCtrl.COMBINATION_TYPE.COMBINATION
	local name = combinationCtrl:getSetName(ctype, self.index)
	self.Text_name:setString(name)
	local combData = combinationCtrl:getCombinationData(self.index)
	if combData then
		local combinationCtrl, setIds = combinationCtrl, combinationCtrl
		for i, slotInfo in ipairs(self.slotList) do
			setIds[i] = combData[slotInfo.fieldKey] or 0
		end
		self.Button_use:setTouchEnabled(false)
		for i, node in ipairs(self.nodeList) do
			if 0 < setIds[i] then
				local setName = combinationCtrl:getSetName(self.slotList[i].ctype, setIds[i])
				node.Text_cname:setString(setName)
				self.Button_use:setTouchEnabled(true)
			else
				node.Text_cname:setString(i18n("common_text_480"))
			end
		end
		self.Button_use:setTouchEnabled(combinationCtrl:hasConfiguredSet(combData))
	else
		self.Button_use:setTouchEnabled(false)
	end
	if self.index == combinationCtrl:getCurSetId() then
		self.Text_inUse:setVisible(true)
	else
		self.Text_inUse:setVisible(false)
	end
end
function combinationItem:setScroll(scroll)
	self.scroll = scroll
	self.Button_config:setScroll(self.scroll)
	self.Button_use:setScroll(self.scroll)
end
function combinationItem:onConfigClick(button, event)
	local panel = SoraDCreatePanel("combinationView")
	panel:initData(self.index)
	panel:show()
end
function combinationItem:onUseClick(button, event)
	local panel = SoraDCreatePanel("combinationCostView")
	panel:initData(self.index)
	panel:show()
end
return combinationItem
