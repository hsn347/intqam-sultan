local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattlePricePanel = class("kingdomBattlePricePanel", baseFguiPanel)
function kingdomBattlePricePanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattlePricePanel:ctor", self.viewName)
end
function kingdomBattlePricePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattlePricePanel:onInit()
	print("=======kingdomBattlePricePanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_2201"), handler(self, self.onClickClose))
	self.fields.Text_intTip:setString(i18n("common_text_2196"))
	self.fields.Text_des:setString(i18n("complement_text_04"))
	self.fields.Com_scoreTitle:fixChildrenPos()
	local titleFields = fguiHelper.get_fields(self.fields.Com_scoreTitle)
	titleFields.Text_person:setString(i18n("common_text_2195"))
	titleFields.Text_kingdom:setString(i18n("complement_text_03"))
	titleFields.Button_help:addClickListener(function()
		SoraDPlaySound()
		uiManager:show("kingdomBattleInfo")
	end)
	self.fields.List_score:setItemRenderer(handler(self, self.onScoreItemRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_stageRank:setItemRenderer(handler(self, self.onStageRankItemRenderer))
	_ENV = self.fields.List_stageRank.setItemRenderer
	_ENV, _ENV, self.fields.List_stageRank.setItemRenderer.defaultClick = handler(self, self.onStageRankItemRenderer)
	_ENV, self.fields.List_stageRank[1], handler(self, self.onStageRankItemRenderer).title = handler(self, self.onStageRankItemRenderer)
	_ENV, self.fields.List_stageRank[2], handler(self, self.onStageRankItemRenderer).title = handler(self, self.onStageRankItemRenderer)
	self.fields.List_stageRank.setItemRenderer.tabsetArray, self.fields.List_stageRank[3], handler(self, self.onStageRankItemRenderer).title = self.fields.List_stageRank, handler(self, self.onStageRankItemRenderer)
	local self.fields.List_stageRank.setItemRenderer.callback, param = handler(self, self.onClickTab), self.fields.List_stageRank.setItemRenderer
	self.fields.com_Tab:initView(param)
end
function kingdomBattlePricePanel:onShow()
	print("=======kingdomBattlePricePanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.controllers.c1:setSelectedIndex(conquestWarCtrl:isDoubleReward() and 0 or 1)
	local myInt = conquestWarCtrl:getPersionalScore()
	_ENV = nil
	;(nil).num = myInt
	self.fields.Text_score:setString(i18n("common_text_2557", nil))
	self.fields.Text_desReward:setString(i18n("conquestwar_text_45"))
	self.scoreInfoList = self.proxy:getScoreInfoList()
	self.fields.List_score:setNumItems(#self.scoreInfoList)
	self.totalRankPrice = self.proxy:getTotalRankPrice()
	self.fields.List_rank:setNumItems(#self.totalRankPrice)
	local curScore = conquestWarCtrl:getKingdomScore()
	self.kingdomRankPrice = self.proxy:getKingdomRankPrice()
	local _ENV, tabsetArray = self.proxy:getKingdomRankPrice(), self.proxy:getKingdomRankPrice()
	local curStage = 1
	for k, v in ipairs(self.kingdomRankPrice[1]) do
		_ENV = i18n("conquestwar_text_45")
		i18n("conquestwar_text_45").title = k
		table.insert(tabsetArray, i18n("conquestwar_text_45"))
		if curScore >= v.scoreStage then
			curStage = k + 1
		end
	end
	curStage = math.min(curStage, #self.kingdomRankPrice[1])
	print("curScore,curStage======", curScore, curStage)
	_ENV = curScore
	curScore.defaultClick = curStage
	curScore.tabsetArray = tabsetArray
	curScore.callback = handler(self, self.onClickStageTab)
	self.fields.Com_stage:initView(curScore)
	_ENV = self
	self.score = fguiHelper.getColorString("#FADB7C", string.formatnumberthousands(curScore))
	self.fields.Text_curScore:setString(i18n("conquestwar_text_67", self))
	local battleState = conquestWarCtrl:getConquestWarState()
	self.fields.Text_curScore:setVisible(battleState >= gConquestWarState.PREPARE)
	local isMaxStageScore = curScore >= self.kingdomRankPrice[1][#self.kingdomRankPrice[1]].scoreStage
	local scoreStage = self.kingdomRankPrice[1][curStage].scoreStage
	if isMaxStageScore then
		self.fields.Text_needScore:setString(i18n("conquestwar_text_69"))
	else
		_ENV = i18n("conquestwar_text_69")
		i18n("conquestwar_text_69").num = curStage
		i18n("conquestwar_text_69").score = fguiHelper.getColorString("#FADB7C", string.formatnumberthousands(scoreStage))
		self.fields.Text_needScore:setString(i18n("conquestwar_text_68", i18n("conquestwar_text_69")))
	end
end
function kingdomBattlePricePanel:onClickStageTab(tag)
	_UPVALUE0_ = nil
	;(nil)[1] = self.kingdomRankPrice[1][tag]
	self.kingdomRankCfg, (nil)[2] = nil, self.kingdomRankPrice[3][tag]
	self.fields.List_stageRank:setNumItems(#self.kingdomRankCfg)
end
function kingdomBattlePricePanel:onClickTab(tag)
	self.controllers.c_viewType:setSelectedIndex(tag - 1)
end
function kingdomBattlePricePanel:onScoreItemRenderer(index, obj)
	local data = self.scoreInfoList[index + 1]
	if not obj.objFields then
		obj.objFields = fguiHelper.get_fields(obj)
		obj:fixChildrenPos()
	end
	local objFields = obj.objFields
	objFields.Text_name:setString(data.right)
	objFields.Text_person:setString(data.left)
	objFields.Text_person:setColor(data.pColor)
	objFields.Text_kingdom:setString(data.king)
	objFields.Text_kingdom:setColor(data.kColor)
	objFields.Image_light:setVisible(index % 2 == 0)
end
function kingdomBattlePricePanel:onRankItemRenderer(index, obj)
	local data = self.totalRankPrice[index + 1]
	if not obj.objFields then
		obj.objFields = fguiHelper.get_fields(obj)
		obj:fixChildrenPos()
	end
	local objFields = obj.objFields
	if data.startrank == data.endrank then
		_ENV = nil
		;(nil).num = data.startrank
		objFields.Text_rank:setString(i18n("common_text_617", nil))
	else
		_ENV = i18n("common_text_617", nil)
		i18n("common_text_617", nil).num = data.startrank .. " - " .. data.endrank
		objFields.Text_rank:setString(i18n("common_text_617", i18n("common_text_617", nil)))
	end
	local List_reward = objFields.List_reward
	List_reward.dataReward = data.reward
	List_reward:setItemRenderer(function(_index, _obj)
		local _data = _obj:getParent().dataReward[_index + 1]
		local _objFields = fguiHelper.get_fields(_obj)
		_obj:fixChildrenPos()
		_objFields.Text_name:setString(publicRead.getName(_data.id))
		_ENV = publicRead.getName(_data.id)
		publicRead.getName(_data.id).num = "x"
		publicRead.getName(_data.id).char = _data.count
		_objFields.Text_count:setString(i18n("common_text_1470", publicRead.getName(_data.id)))
		if conquestWarCtrl:isDoubleReward() and data.addReward[_data.id] then
			_objFields.Text_extraCount:setVisible(true)
			_objFields.Text_extraCount:setString(string.format("+%d", data.addReward[_data.id]))
		end
		_objFields.Com_item:initData(_data.id)
	end)
	local numItems = #data.reward
	List_reward:setNumItems(numItems)
	List_reward:setContentSize(cc.size(List_reward:getContentSize().width, 92 * numItems))
end
function kingdomBattlePricePanel:onStageRankItemRenderer(index, obj)
	local data = self.kingdomRankCfg[index + 1]
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local reward = serviceFunctions.tableFormat(data.reward, nil)
	if not obj.objFields then
		obj.objFields = fguiHelper.get_fields(obj)
		obj:fixChildrenPos()
	end
	local objFields = obj.objFields
	objFields.Text_rank:setString(index + 1 == 1 and i18n("conquestwar_text_70") or i18n("conquestwar_text_71"))
	objFields.Text_rank:getChild("title"):setColor(SoraDHtmlColor2RGB("#C67832"))
	local List_reward = objFields.List_reward
	List_reward.dataReward = reward
	List_reward:setItemRenderer(function(_index, _obj)
		local _data = _obj:getParent().dataReward[_index + 1]
		local _objFields = fguiHelper.get_fields(_obj)
		_obj:fixChildrenPos()
		_objFields.Text_name:setString(publicRead.getName(_data.id))
		_ENV = publicRead.getName(_data.id)
		publicRead.getName(_data.id).num = "x"
		publicRead.getName(_data.id).char = _data.count
		_objFields.Text_count:setString(i18n("common_text_1470", publicRead.getName(_data.id)))
		_objFields.Text_extraCount:setVisible(false)
		_objFields.Com_item:initData(_data.id)
	end)
	local numItems = #reward
	List_reward:setNumItems(numItems)
	List_reward:setContentSize(cc.size(List_reward:getContentSize().width, 92 * numItems))
end
return kingdomBattlePricePanel
