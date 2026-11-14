local remainsWarCtrl = SoraDGetCtrl("remainsWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local remainsWarBuffPanel = class("remainsWarBuffPanel", baseFguiPanel)
function remainsWarBuffPanel:ctor(...)
	remainsWarBuffPanel.super.ctor(self, ...)
	print("remainsWarBuffPanel:ctor", self.viewName)
end
function remainsWarBuffPanel:onInit()
	print("=======remainsWarBuffPanel:onInit")
	self.tag = 1
	self.buffList, _ENV, self.isInit = print, print, true
	self.fields.Com_title:initData(i18n("remains_optimize_text2"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:setBtnHelpVisible(IsArClient and not SoraDGetCtrl("djCtrl").isDJ)
	self.fields.Text_notice:setString(i18n("remains_text_184"))
	self.fields.Text_notice:setVisible(false)
	self.fields.List_buff:setItemRenderer(handler(self, self.onItemRenderer))
end
function remainsWarBuffPanel:onItemRenderer(index, obj)
	obj:initData(self.buffList[index + 1], index + 1)
end
function remainsWarBuffPanel:onShow()
	print("=======remainsWarBuffPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.kid = self.param and self.param.kid
	self.uid = self.param and self.param.uid
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("common_text_311")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("remains_optimize_text7")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(nil)
end
function remainsWarBuffPanel:req4Info()
	SoraDShowLoading(self)
	remainsWarCtrl:reqPlayerBuffList(self.kid, self.uid)
end
function remainsWarBuffPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		if self.kid and self.uid then
			if self.isInit then
				self.isInit = false
				self:req4Info()
			else
				self:initView()
			end
		else
			self:initView()
		end
	else
		self.fields.Text_notice:setVisible(false)
	end
end
function remainsWarBuffPanel:getBuffEffectWeight(effect)
	if effect == gBuffEffect.RUINS_WAR_SEND_ROME then
		return 100
	elseif effect == gBuffEffect.RUINS_WAR_LOCK_PLAYER_MOVE_CITY or effect == gBuffEffect.RUINS_WAR_LOCK_PLAYER_SPEED_QUEUE then
		return 10
	end
	return 1
end
local sortList = function(buffList)
	local _ENV, arryList
	for _, v in pairs(buffList) do
		table.insert(arryList, v)
	end
	table.sort(arryList, function(buff1, buff2)
		if buff1.weight ~= buff2.weight then
			return buff1.weight > buff2.weight
		end
		return buff2.id < buff1.id
	end)
	return arryList
end
function remainsWarBuffPanel:switchList(target, data)
	self.buffList[data.index].isOpen = data.isOpen
	self.fields.List_buff:setNumItems(#self.buffList)
end
function remainsWarBuffPanel:initView(target, data)
	SoraDCloseLoading(self)
	local getBuffList = function(bufflist)
		local _ENV, finalList
		for i, v in pairs(bufflist) do
			local data
			for k, m in pairs(finalList) do
				if m.src == v.src and m.effect == v.effect then
					data = m
					break
				end
			end
			if not data then
				data.data, _ENV, data, _ENV = pairs(finalList)
				data.id = v.id
				data.src = v.src
				data.effect = v.effect
				data.showData = clone(v)
				data.showData.value = 0
				data.leftTime = 0
				data.weight = self:getBuffEffectWeight(data.effect)
				table.insert(finalList, data)
			end
			data.showData.value = data.showData.value + v.value
			local leftTime = v.endTime - serviceFunctions.systemTime()
			if leftTime > data.leftTime then
				data.showData.beginTime = v.beginTime
				data.showData.endTime = v.endTime
				data.leftTime = leftTime
			end
			table.insert(data.data, v)
		end
		return finalList
	end
	local bufflist = remainsWarCtrl:getRemainsWarTeamBuffList()
	self.buffTeamList = sortList(getBuffList(bufflist))
	bufflist = remainsWarCtrl:getRemainsWarPlayerBuffList()
	self.buffPlayerList = sortList(getBuffList(bufflist))
	self:initScrollList()
end
function remainsWarBuffPanel:initScrollList()
	self.buffList, _ENV = nil, nil
	local systemTime = serviceFunctions.systemTime()
	for _, v in ipairs(self.buffTeamList) do
		for i, m in ipairs(v.data) do
			local timeRemains = m.endTime - systemTime
			if 0 < timeRemains then
				_ENV = nil
				;(nil).data = v
				;(nil).isOpen = false
				table.insert(self.buffList, nil)
				break
			end
		end
	end
	for _, v in ipairs(self.buffPlayerList) do
		for i, m in ipairs(v.data) do
			local timeRemains = m.endTime - systemTime
			if 0 < timeRemains then
				_ENV = nil
				;(nil).data = v
				;(nil).isOpen = false
				table.insert(self.buffList, nil)
				break
			end
		end
	end
	self.fields.Text_notice:setVisible(#self.buffList <= 0 and self.tag == 1 or false)
	self.fields.List_buff:setNumItems(#self.buffList)
	self.fields.List_buff:jumpToTop()
end
function remainsWarBuffPanel:initBuff(target, data)
	SoraDCloseLoading(self)
	self:initView()
end
function remainsWarBuffPanel:rspRomeAttackBack(target, data)
	SoraDCloseLoading(self)
end
function remainsWarBuffPanel:onClickHelp()
	SoraDPlaySound()
	if not _G.IsArClient then
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR_EN)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.REMAIS_WAR)
	end
end
return remainsWarBuffPanel
