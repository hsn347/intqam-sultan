local royalSummonsTab = class("royalSummonsTab", function(target)
	return target
end)
function royalSummonsTab:ctor()
end
function royalSummonsTab:initTabData(data)
	self.tableData = data
	for i, v in ipairs(self.tableData) do
		local btnScore = SoraDGetChildByName(self, v.title)
		btnScore:setTag(i)
		btnScore:setPressedActionEnabled(false)
		btnScore:setTitleText(i18n(v.titleText))
		btnScore:addTouchEventListener(handler(self, self.OnBtnChangeClick))
		_G.SoraDAutoSizeButtonTextByContent(btnScore)
		v.button = btnScore
		v.panel = nil
	end
	self.showViewType = nil
end
function royalSummonsTab:initShowBtn(showViewType)
	if self.showViewType == showViewType then
		return
	end
	self.showViewType = showViewType
	for i, v in ipairs(self.tableData) do
		local panel, refresh = self:showTab_imp(i, v)
		if panel and self.initShowBtn_post then
			self:initShowBtn_post(panel, refresh)
		end
	end
end
function royalSummonsTab:showTab_imp(i, v)
	local panel
	local refresh = false
	local btn = v.button
	local show = i == self.showViewType
	btn:setTouchEnabled(not show)
	if show then
		btn:setTitleColor(cc.c3b(255, 245, 176))
		btn:loadTextureNormal("btn_alliance_special.png", ccui.TextureResType.plistType)
		if not v.panel then
			v.panel = self:createPanel(self.showViewType)
		else
			refresh = true
		end
		if v.panel then
			v.panel:setVisible(true)
			panel = v.panel
		end
	else
		btn:setTitleColor(cc.c3b(144, 132, 97))
		btn:loadTextureNormal("btn_alliance_click.png", ccui.TextureResType.plistType)
		if v.panel then
			v.panel:setVisible(false)
		end
	end
	return panel, refresh
end
function royalSummonsTab:switchToTab(showViewType)
	showViewType = showViewType or self.showViewType
	local v = self.tableData[showViewType]
	if v then
		local panel, refresh = self:showTab_imp(showViewType, v)
		if self.initShowBtn_post then
			self:initShowBtn_post(panel, refresh)
		end
	end
end
function royalSummonsTab:OnBtnChangeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = button:getTag()
		self:initShowBtn(tag)
	end
end
return royalSummonsTab
