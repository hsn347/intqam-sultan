local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DivineBeastMarkBagPanel = class("DivineBeastMarkBagPanel", baseFguiPanel)
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local publicRead = include("publicRead")
function DivineBeastMarkBagPanel:ctor(...)
	DivineBeastMarkBagPanel.super.ctor(self, ...)
	self.debug = true
	print("DivineBeastMarkBagPanel:ctor", self.viewName)
end
function DivineBeastMarkBagPanel:onInit()
	print("=======DivineBeastMarkBagPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_308"), handler(self, self.onClickClose))
	self.fields.Txt_tip:setString(i18n("Divine_beast_mark_text_21"))
	self.fields.Btn_quality:setTitle(i18n("commandhall_text_52"))
	self.fields.Btn_quality:addClickEventListener(handler(self, self.onQualityClick))
	self.fields.Btn_army:setTitle(i18n("mail_2_text_35"))
	self.fields.Btn_army:addClickEventListener(handler(self, self.onArmyClick))
	self.fields.Btn_change:setTitle(i18n("mark_optimal_text_01"))
	self.fields.Btn_change:addClickEventListener(handler(self, self.onChangeClick))
	self.fields.Btn_recycle:setTitle(i18n("Divine_beast_mark_text_26"))
	self.fields.Btn_recycle:addClickEventListener(handler(self, self.onRecycleClick))
	self.itemID = gIDDef.DIVINE_BEAST_MARK_EXP
	self.fields.Com_MC_Have:setIcon(publicRead.getIcon(self.itemID))
	self.fields.Com_MC_Have:addClickEventListener(handler(self, self.onGetItem))
	self.filterArmy, _ENV, self.filterQuality, _ENV = self.fields.Com_MC_Have.addClickEventListener, self.fields.Com_MC_Have.addClickEventListener, self.fields.Com_MC_Have.addClickEventListener, self.fields.Com_MC_Have.addClickEventListener
	self.fields.Usm_starUp:setCompleteCallback(function()
		self.fields.Usm_starUp:setVisible(false)
		self.fields.Usm_starUp:clearEffect()
	end)
	self.fields.Btn_quality:fixPos()
	self.fields.Btn_army:fixPos()
	self.fields.Btn_change:fixPos()
	self.fields.Btn_recycle:fixPos()
end
function DivineBeastMarkBagPanel:onShow()
	print("=======DivineBeastMarkBagPanel:onShow")
	self:updateView()
	self:updateExp()
	self.transitions.t0:play(1, 0, 0, -1)
end
function DivineBeastMarkBagPanel:updateView(bagMarkId, dataType)
	local bagMarkData = divineBeastMarkCtrl:getBagMarkList()
	self.markList, divineBeastMarkCtrl = divineBeastMarkCtrl, divineBeastMarkCtrl
	for _, v in pairs(bagMarkData) do
		local cfg = v.markCfg
		if cfg and not self.filterArmy[cfg.army_id] and not self.filterQuality[cfg.quality] then
			divineBeastMarkCtrl = self.filterQuality[cfg.quality]
			local self.filterQuality[cfg.quality].data, markData = v, self.filterQuality[cfg.quality]
			markData.order = (v.slot ~= nil and 1000000 or 0) + v.lv * 100 + cfg.quality * 10 + v.lock
			table.insert(self.markList, markData)
		end
	end
	table.sort(self.markList, function(a, b)
		if a.order ~= b.order then
			return a.order > b.order
		end
		return a.data.markId > b.data.markId
	end)
	self.fields.Com_MC_bag:initData(self.markList, bagMarkId)
	self.fields.Com_MC_bag:jumpTop()
	self.fields.Txt_tip:setVisible(#self.markList == 0)
	if dataType == "star" then
		self:showStarUp()
	end
end
function DivineBeastMarkBagPanel:showStarUp()
	local curMark = self.fields.Com_MC_bag:getCurItem()
	if curMark then
		self.fields.Usm_starUp:clearEffect()
		self.fields.Usm_starUp:setVisible(true)
		self.fields.Usm_starUp:setEffectPath("ssyj_effect_sx.usm", false)
		local pos = self.fields.Com_MC_bag:localToGlobal(curMark:getPosition())
		pos = self.view:globalToLocal(pos)
		self.fields.Usm_starUp:setPosition(pos.x + 60, pos.y + 60)
	end
end
function DivineBeastMarkBagPanel:updateExp()
	self.expCount = divineBeastMarkCtrl:getExpCount()
	self.fields.Com_MC_Have:setTitle(self.expCount)
end
function DivineBeastMarkBagPanel:onQualityClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).filterData = self.filterQuality
	;(nil).filterType = 2
	;(nil).sureCallback = function(filterData)
		self.filterQuality = filterData
		self:updateView()
	end
	uiManager:show("DivineBeastMarkFilter", nil)
end
function DivineBeastMarkBagPanel:onArmyClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).filterData = self.filterArmy
	;(nil).filterType = 1
	;(nil).sureCallback = function(filterData)
		self.filterArmy = filterData
		self:updateView()
	end
	uiManager:show("DivineBeastMarkFilter", nil)
end
function DivineBeastMarkBagPanel:onGetMoreClick()
	SoraDPlaySound()
	_UPVALUE1_, _ENV = nil, nil
	;(nil).sources, (nil)[1] = nil, 274
	uiManager:show("CommonSourceGuide", nil)
end
function DivineBeastMarkBagPanel:onChangeClick()
	SoraDPlaySound()
	uiManager:show("DivineBeastMarkChangeChoose")
end
function DivineBeastMarkBagPanel:onRecycleClick()
	SoraDPlaySound()
	uiManager:show("DivineBeastMarkRecycle")
end
function DivineBeastMarkBagPanel:onGetItem()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
return DivineBeastMarkBagPanel
