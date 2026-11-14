local MAX_AWARD_NUM = 5
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local playerMobilizationCtrl = SoraDGetCtrl("playerMobilizationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001604_reward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001604/Com_9001604_reward", Com_9001604_reward)
function Com_9001604_reward:onInit()
	self.itemList, _ENV = nil, nil
	self.fields.List_items:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_items:setAlignCenter(true)
end
function Com_9001604_reward:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
end
function Com_9001604_reward:onShow()
end
function Com_9001604_reward:initData(data, tag)
	self.data = data
	self.tag = tag
	if self.tag == 1 then
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c2:setSelectedIndex(0)
		_ENV = nil
		;(nil).num = self.data.stage
		self.fields.Text_rank:setString(i18n("Ramadan_League_text_19", nil))
		self:setHeight(190)
	else
		local rankStart = self.data.rank[1]
		local rankEnd = self.data.rank[2]
		local showStr = rankStart == rankEnd and rankStart or rankStart .. "~" .. rankEnd
		_ENV = i18n("Ramadan_League_text_19", nil)
		i18n("Ramadan_League_text_19", nil).num = showStr
		self.fields.Text_rank:setString(i18n("common_text_617", i18n("Ramadan_League_text_19", nil)))
		if rankStart <= RANK_TOP_SPECIAL then
			self.controllers.c1:setSelectedIndex(1)
			self.fields.icon:setSpriteFrame("icon_ranking_" .. rankStart .. ".png")
			if rankStart <= 3 then
				self.controllers.c2:setSelectedIndex(1)
				local flagNode = SoraDGetAllianceFlagByFid(17 + rankStart)
				flagNode:setScale(0.6)
				flagNode:setPosition(50, 50)
				self.fields.flag:setContent(flagNode)
				self:setHeight(350)
				self.fields.Text_topOne:setString(i18n("Ramadan_League_text_" .. 19 + rankStart))
			else
				self.controllers.c2:setSelectedIndex(0)
				self:setHeight(190)
			end
			self.fields.Text_rank:fixPos()
			self.fields.icon:fixPos()
		else
			self.controllers.c1:setSelectedIndex(0)
			self.controllers.c2:setSelectedIndex(0)
			self:setHeight(190)
		end
	end
	self:setAward()
end
function Com_9001604_reward:setAward()
	self.itemList = self.data.reward
	self.fields.List_items:setNumItems(#self.itemList)
end
return Com_9001604_reward
