local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkIllusionDetailPanel = class("DivineBeastMarkIllusionDetailPanel", baseFguiPanel)
local divineBeastMarkRead = include("divineBeastMarkRead")
function DivineBeastMarkIllusionDetailPanel:ctor(...)
	DivineBeastMarkIllusionDetailPanel.super.ctor(self, ...)
	print("DivineBeastMarkIllusionDetailPanel:ctor", self.viewName)
	self.debug = true
end
function DivineBeastMarkIllusionDetailPanel:onInit()
	print("=======DivineBeastMarkIllusionDetailPanel:onInit")
	self.markCfg = self.param.markCfg
	self.fields.Com_MC_Mark:forbidLongPress()
	self.fields.Panel_bg:setTitle(i18n(self.markCfg.name))
	self.fields.btn_quality:setTitle(i18n("Divine_beast_mark_text_86"))
	self.fields.btn_quality:addClickEventListener(handler(self, self.onQualityClick))
	self.fields.btn_level:setTitle(i18n("Divine_beast_mark_text_87"))
	self.fields.btn_level:addClickEventListener(handler(self, self.onLevelClick))
	self.fields.btn_att:setTitle(i18n("Divine_beast_mark_text_88"))
	self.fields.btn_att:addClickEventListener(handler(self, self.onAttClick))
	self.minLvCfg = divineBeastMarkRead.getLvCfg(self.markCfg.ID, 0)
	self.maxLvCfg = divineBeastMarkRead.getMaxLvCfg(self.markCfg.ID)
	self.markCfgList = divineBeastMarkRead.getMarkCfgList(self.markCfg.type)
	self.isMaxLv = true
	self.fields.Com_MC_illusionSelect:setSelectCallback(function(index)
		self.quality = index
		dump(self.quality, "self.quality")
		self:initData()
	end)
	self.view:fixChildrenPos()
end
function DivineBeastMarkIllusionDetailPanel:onQualityClick(sender)
	SoraDPlaySound()
	self.fields.Com_MC_illusionSelect:setVisible(not self.fields.Com_MC_illusionSelect:isVisible())
end
function DivineBeastMarkIllusionDetailPanel:onLevelClick(sender)
	SoraDPlaySound()
	self.isMaxLv = not self.isMaxLv
	self:initData()
end
function DivineBeastMarkIllusionDetailPanel:onAttClick(sender)
	SoraDPlaySound()
	_ENV, _ENV = nil, nil
	;(nil).mark, (nil).markCfg = nil, self.curMarkCfg
	uiManager:show("DivineBeastMarkRecount", nil)
end
function DivineBeastMarkIllusionDetailPanel:onShow()
	print("=======DivineBeastMarkIllusionDetailPanel:onShow")
	self:initData()
end
function DivineBeastMarkIllusionDetailPanel:initData()
	local markCfg
	local quality = 0
	for i, v in ipairs(self.markCfgList) do
		if quality <= v.quality then
			markCfg = v
			quality = v.quality
		end
	end
	self.curMarkCfg = markCfg
	self.minLvCfg = divineBeastMarkRead.getLvCfg(markCfg.ID, 0)
	self.maxLvCfg = divineBeastMarkRead.getMaxLvCfg(markCfg.ID)
	local lv = self.isMaxLv and self.maxLvCfg.lv or 0
	local star = self.isMaxLv and self.maxLvCfg.need_star or 0
	local lvCfg = self.isMaxLv and self.maxLvCfg or self.minLvCfg
	self.fields.btn_level:setTitle(i18n(self.isMaxLv and "Divine_beast_mark_text_89" or "Divine_beast_mark_text_87"))
	self.fields.Com_MC_Mark:initData(markCfg.ID)
	self.fields.Com_MC_Mark:getSetupItemUI():hideSelf()
	_ENV = i18n(self.isMaxLv and "Divine_beast_mark_text_89" or "Divine_beast_mark_text_87")
	i18n(self.isMaxLv and "Divine_beast_mark_text_89" or "Divine_beast_mark_text_87").lv = lv
	self.fields.lv_now:setString(i18n("common_text_100", i18n(self.isMaxLv and "Divine_beast_mark_text_89" or "Divine_beast_mark_text_87")))
	self.fields.txt_name:setString(i18n(markCfg.name))
	local starCfg = divineBeastMarkRead.getStarCfg(star)
	self.fields.txt_fc:setString(lvCfg.power + starCfg.power)
	self.fields.Com_MC_Stars:initData(star)
	local elements = markCfg.elements
	local elements_lv = markCfg.elements_lv
	local randomElement = 0
	for index = 1, 5 do
		local obj = self.fields["element" .. index]
		local element = elements[index]
		obj:setVisible(element ~= nil)
		if element ~= nil then
			element = element == 5 and 0 < randomElement and randomElement or element
			obj:setURL(divineBeastMarkRead.getElementIcon(element))
			obj:setGrayed((elements_lv[index] or 0) > (lv or 0))
		end
	end
	for i = 1, 2 do
		local randomBuffLv = markCfg.randombuff_lv[i]
		self.fields["text_buff" .. i]:setVisible(randomBuffLv ~= nil)
		self.fields["text_lock" .. i]:setVisible(randomBuffLv ~= nil)
		if randomBuffLv then
			local buffStr = i18n("Divine_beast_mark_text_18")
			_ENV = (elements_lv[index] or 0) > (lv or 0)
			;(elements_lv[index] or 0) > (lv or 0).num = randomBuffLv
			local valueStr = i18n("Divine_beast_mark_text_17", (elements_lv[index] or 0) > (lv or 0))
			self.fields["text_buff" .. i]:setString(buffStr)
			self.fields["text_lock" .. i]:setString(valueStr)
		end
	end
	self.fields.text_desc1:setString(i18n(lvCfg.introduce))
end
return DivineBeastMarkIllusionDetailPanel
