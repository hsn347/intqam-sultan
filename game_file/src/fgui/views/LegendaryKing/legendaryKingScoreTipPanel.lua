local legendRewardRead = include("legendRewardRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local legendaryKingScoreTipPanel = class("legendaryKingScoreTipPanel", baseFguiPanel)
function legendaryKingScoreTipPanel:ctor(...)
	self.isLRU = true
	legendaryKingScoreTipPanel.super.ctor(self, ...)
	print("legendaryKingScoreTipPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_
end
function legendaryKingScoreTipPanel:onInit()
	print("=======legendaryKingScoreTipPanel:onInit")
	self.fields.listReq:setVirtual()
	self.fields.listReq:setItemRenderer(handler(self, self.itemRenderer_listReq))
	self.fields.Panel_bg:setString(i18n("common_text_4421"))
end
function legendaryKingScoreTipPanel:endShow()
	print("=======legendaryKingScoreTipPanel:endShow")
	self:initData(self.param)
end
function legendaryKingScoreTipPanel:itemRenderer_listReq(index, obj)
	local data = self.itemList[index + 1]
	obj:getController("ctrlLight"):setSelectedIndex(index % 2)
	local scoreInfo = data.scoreInfo
	_ENV = nil
	_ENV, _ENV, (nil).point = nil, scoreInfo.score, scoreInfo.score
	_ENV, scoreInfo.score.point, (nil).color = nil, nil, "#FFD43E"
	scoreInfo.score.__default, (nil).color = nil, "#D7C39B"
	obj:getChild("txtScore"):setString(i18n_html("common_text_2200", nil, scoreInfo.score))
	_ENV = i18n_html("common_text_2200", nil, scoreInfo.score)
	i18n_html("common_text_2200", nil, scoreInfo.score).count = scoreInfo.des.count
	_ENV, _ENV, i18n_html("common_text_2200", nil, scoreInfo.score).level = i18n_html("common_text_2200", nil, scoreInfo.score)
	_ENV, scoreInfo.des.level.count, i18n_html("common_text_2200", nil, scoreInfo.score).color = i18n_html("common_text_2200", nil, scoreInfo.score)
	_ENV, scoreInfo.des.level.level, i18n_html("common_text_2200", nil, scoreInfo.score).color = i18n_html("common_text_2200", nil, scoreInfo.score)
	scoreInfo.des.level.__default, i18n_html("common_text_2200", nil, scoreInfo.score).color = i18n_html("common_text_2200", nil, scoreInfo.score)
	obj:getChild("txtReq"):setString(i18n_html(scoreInfo.des[1], i18n_html("common_text_2200", nil, scoreInfo.score)))
end
function legendaryKingScoreTipPanel:initData(data)
	self.data = data
	local score = data.score
	_ENV = nil
	;(nil).num = string.formatnumberthousands(score)
	self.fields.txtScore:setString(i18n("common_text_2557", nil))
	if self.data.stageType == gLegendStageType.KING then
		self.fields.txtDesc:setString(i18n("legendaryking_text_33"))
	elseif self.data.stageType == gLegendStageType.KING_STAR then
		self.fields.txtDesc:setString(i18n("kingstarbattle_text_40"))
	elseif self.data.stageType == gLegendStageType.HEGEMON then
		self.fields.txtDesc:setString(i18n("hegemon_text_53"))
	end
	local reqType
	if data.personalType == gLegendPersonalStageRewardType.NORMAL then
	elseif data.personalType == gLegendPersonalStageRewardType.KILL then
		self.fields.txtDesc:setString(i18n("legendaryking_text_102"))
		reqType = 1
	elseif data.personalType == gLegendPersonalStageRewardType.LOSE then
		self.fields.txtDesc:setString(i18n("legendaryking_text_103"))
		reqType = 2
	end
	local scoreConf = legendRewardRead.getScoreConf(self.data.stageType, self.data.mapid)
	if not scoreConf then
		return
	end
	self.itemList, _ENV = self.data.stageType, self.data.stageType
	if reqType then
		for i, v in ipairs(scoreConf) do
			if v.type == reqType then
				_ENV = i18n("legendaryking_text_103")
				i18n("legendaryking_text_103").index = i
				i18n("legendaryking_text_103").scoreInfo = v
				table.insert(self.itemList, i18n("legendaryking_text_103"))
			end
		end
	else
		for i, v in ipairs(scoreConf) do
			_ENV = i18n("legendaryking_text_103")
			i18n("legendaryking_text_103").index = i
			i18n("legendaryking_text_103").scoreInfo = v
			table.insert(self.itemList, i18n("legendaryking_text_103"))
		end
	end
	dump(self.itemList, "self.itemList ")
	self.fields.listReq:setNumItems(#self.itemList)
end
return legendaryKingScoreTipPanel
