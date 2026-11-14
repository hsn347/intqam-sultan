local AllianceSettingsView = class("allianceSettingsView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceSettingsView")
	end
	return target
end)
function AllianceSettingsView:ctor()
	self.tableSingle, _ENV, self.tableMenu, _ENV = nil, nil, nil, nil
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_259"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_settings")
	self:initData()
end
function AllianceSettingsView:initData()
	self.isHaveTextField = true
	local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
	self.tableMenu = permissionCtrl:getSettingsMenu()
	self:initScroll()
	self:updateScrollView()
end
function AllianceSettingsView:initScroll()
	for i, v in ipairs(self.tableMenu) do
		local single = SoraDCreatePanel("allianceSettingsListSingle")
		single:setClickCallBack(handler(self, self.updateScrollView))
		single:setScroll(self.scroll)
		single:addTo(self.scroll)
		table.insert(self.tableSingle, single)
		single:setTag(v)
		single:initData(v)
	end
end
function AllianceSettingsView:updateScrollView(target, tag, state)
	for i, v in ipairs(self.tableSingle) do
		if v:getTag() ~= tag then
			v:setState(false)
		end
	end
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = 0
	for i = 1, #self.tableSingle do
		local single = self.tableSingle[#self.tableSingle - i + 1]
		scrollInnerNewH = scrollInnerNewH + single:getSingleH()
		single:setPosition(cc.p(320, scrollInnerNewH))
	end
	if scrollInnerNewH < self.scroll:getContentSize().height then
		local upto = self.scroll:getContentSize().height - scrollInnerNewH
		for i, v in ipairs(self.tableSingle) do
			v:setPositionY(v:getPositionY() + upto)
		end
		scrollInnerNewH = self.scroll:getContentSize().height
	end
	offsetY = math.min(0, offsetY - (scrollInnerNewH - scrollInner:getContentSize().height))
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	if tag == gaSettings.LANGUAGE and state == true then
		scrollInner:setPositionY(self.scroll:getContentSize().height - target:getPositionY() - 95)
		self.scroll:setTouchEnabled(false)
	elseif tag == gaSettings.RANK and state == true then
		scrollInner:setPositionY(self.scroll:getContentSize().height - target:getPositionY())
		self.scroll:setTouchEnabled(false)
	else
		self.scroll:setTouchEnabled(true)
		if tag == gaSettings.COLOR and state == true then
			self.scroll:jumpToBottom()
		end
	end
end
return AllianceSettingsView
