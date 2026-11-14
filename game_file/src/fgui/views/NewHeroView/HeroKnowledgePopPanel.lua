local heroTaskRead = include("heroTaskRead")
local cityltCtrl = include("cityltCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroTaskCtrl = SoraDGetCtrl("heroTaskCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroKnowledgePopPanel = class("HeroKnowledgePopPanel", baseFguiPanel)
function HeroKnowledgePopPanel:ctor(...)
	HeroKnowledgePopPanel.super.ctor(self, ...)
	print("HeroKnowledgePopPanel:ctor", self.viewName)
end
function HeroKnowledgePopPanel:onInit()
	print("=======HeroKnowledgePopPanel:onInit")
	self.heros, _ENV, self.reward, _ENV = print, print, print, print
	self.effectTb, _ENV, self.increase = print, print, 0
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_heros:setItemRenderer(handler(self, self.onHeroRenderer))
	self.fields.Lab_hero:setString(i18n("hero_title_07"))
	self.fields.Text_exBonus:setString(i18n("hero_appoint_30"))
	self.fields.Text_bonus:setString("0%")
	self.fields.Btn_quickSelect:setString(i18n("hero_appoint_31"))
	self.fields.Btn_quickSelect:addClickListener(handler(self, self.btnQuickClick))
	self.fields.Btn_dispatch:setString(i18n("hero_appoint_20"))
	self.fields.Btn_dispatch:addClickListener(handler(self, self.btnDispatchClick))
	self.fields.Btn_quickSelect:fixPos()
	self.fields.Btn_dispatch:fixPos()
end
function HeroKnowledgePopPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, math.floor(self.reward[index + 1].count * (1 + self.increase)))
end
function HeroKnowledgePopPanel:onHeroRenderer(index, obj)
	obj:initData(self.heros[index + 1], index + 1, self.heros)
end
function HeroKnowledgePopPanel:onShow()
	print("=======HeroKnowledgePopPanel:onShow")
	self.data = self.param.data
	self.cfg = heroTaskRead.getTaskConfig(self.data.id)
	self.fields.Panel_bg:setString(i18n(self.cfg.taskName))
	self.fields.Text_des:setString(i18n(self.cfg.taskDes))
	self:updateInCreaseCond()
	self:updateView()
end
function HeroKnowledgePopPanel:selectHeroBack(target, data)
	local index = data.index
	local heroID = data.heroID
	self.heros[index] = heroID
	self.fields.List_heros:setNumItems(self.cfg.heroNum)
	self:updateShow()
	local heros = table.values(self.heros)
	self.fields.Btn_quickSelect:setEnabled(#heros < self.cfg.heroNum)
end
function HeroKnowledgePopPanel:updateShow()
	local heros = table.values(self.heros)
	self.increase, self.effectTb = heroTaskRead.getRewardIncrease(self.data.id, heros)
	self.fields.Text_bonus:setString(self.increase * 100 .. "%")
	self:updateReward()
	self:updateInCreaseCond()
end
function HeroKnowledgePopPanel:updateInCreaseCond()
	local _ENV, attrTb
	_UPVALUE3_ = nil
	;(nil)[1] = "type"
	;(nil)[2] = "enum"
	;(nil)[3] = "val"
	local taskNeed = serviceFunctions.tableFormat(self.cfg.taskNeed, nil)
	for k, v in ipairs(taskNeed) do
		if v.type == 1 then
			_ENV = nil
			;(nil).type = i18n(heroltCtrl.getHeroClassTypeName(v.enum))
			;(nil).num = v.val
			table.insert(attrTb, fguiHelper.getColorString(self.effectTb[k] and "#70C723" or "#746E65", i18n("hero_taskdes_8", nil)))
		elseif v.type == 2 then
			_ENV = fguiHelper.getColorString(self.effectTb[k] and "#70C723" or "#746E65", i18n("hero_taskdes_8", nil))
			fguiHelper.getColorString(self.effectTb[k] and "#70C723" or "#746E65", i18n("hero_taskdes_8", nil)).attr = cityltCtrl.getHeroAttrName(v.enum)
			fguiHelper.getColorString(self.effectTb[k] and "#70C723" or "#746E65", i18n("hero_taskdes_8", nil)).sum = v.val
			table.insert(attrTb, fguiHelper.getColorString(self.effectTb[k] and "#70C723" or "#746E65", i18n("hero_taskdes_9", fguiHelper.getColorString(self.effectTb[k] and "#70C723" or "#746E65", i18n("hero_taskdes_8", nil)))))
		end
	end
	self.fields.Lab_attr:setString(table.concat(attrTb, "\n"))
end
function HeroKnowledgePopPanel:updateView()
	self:updateReward()
	self:updateHeros()
end
function HeroKnowledgePopPanel:updateReward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.reward = serviceFunctions.tableFormat(self.cfg.taskReward, nil)
	self.fields.List_reward:setNumItems(#self.reward)
end
function HeroKnowledgePopPanel:updateHeros()
	if not self.data.heros then
		_UPVALUE0_ = self.data.heros
	end
	self.heros = self.data.heros
	self.fields.List_heros:setNumItems(self.cfg.heroNum)
end
function HeroKnowledgePopPanel:btnQuickClick()
	SoraDPlaySound()
	local myHeroList = heroCtrl:getHaveHerosList()
	local heros = table.values(self.heros)
	local _ENV, maybeList = self.heros, self.heros
	for k, v in ipairs(myHeroList) do
		local heroID = tonumber(v)
		if not heroTaskCtrl:isHeroInTask(heroID) and not SoraDisInList(heroID, heros) then
			table.insert(maybeList, heroID)
		end
	end
	heroltCtrl = ipairs(myHeroList)
	ipairs(myHeroList)[1] = "type"
	ipairs(myHeroList)[2] = "enum"
	ipairs(myHeroList)[3] = "val"
	local taskNeed = serviceFunctions.tableFormat(self.cfg.taskNeed, ipairs(myHeroList))
	local _ENV, selectMap = self.cfg.taskNeed, self.cfg.taskNeed
	for k, v in ipairs(maybeList) do
		local heroType = heroltCtrl.getHeroType(v)
		local attrTb = heroltCtrl:getHeroAppointAttr(v)
		local condNum = 0
		local cType = 0
		for ki, vi in ipairs(taskNeed) do
			cType = vi.type == 1 and 0 or 1
			if vi.type == 1 and vi.enum == heroType then
				condNum = condNum + 1
			end
			if vi.type == 2 and vi.val / #taskNeed <= attrTb[vi.enum] then
				condNum = condNum + 1
			end
		end
		_ENV = ipairs(taskNeed)
		ipairs(taskNeed).heroID = v
		ipairs(taskNeed).condNum = condNum
		ipairs(taskNeed).cType = cType
		table.insert(selectMap, ipairs(taskNeed))
	end
	table.sort(selectMap, function(a, b)
		if a.condNum == b.condNum then
			return a.cType < b.cType
		else
			return a.condNum > b.condNum
		end
	end)
	local index = 1
	for i = 1, self.cfg.heroNum do
		local selectID = selectMap[index] and selectMap[index].heroID or maybeList[index]
		if not self.heros[i] and selectID then
			self.heros[i] = selectID
			index = index + 1
		end
	end
	self.fields.List_heros:setNumItems(self.cfg.heroNum)
	self:updateShow()
end
function HeroKnowledgePopPanel:btnDispatchClick()
	SoraDPlaySound()
	local heros = table.values(self.heros)
	if #heros < 1 then
		SoraDShowMsgTip(i18n("hero_appoint_34"))
		return
	end
	heroTaskCtrl:reqStarTask(self.data.id, heros)
	self:close()
end
return HeroKnowledgePopPanel
