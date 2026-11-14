local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleHonourBoardPanel = class("kingdomBattleHonourBoardPanel", baseFguiPanel)
function kingdomBattleHonourBoardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattleHonourBoardPanel:ctor", self.viewName)
end
function kingdomBattleHonourBoardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattleHonourBoardPanel:onInit()
	print("=======kingdomBattleHonourBoardPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_3361"), handler(self, self.onClickClose))
	local titleFields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	titleFields.Text_name:setString(i18n("common_text_2037"))
	titleFields.Text_score:setString(i18n("common_text_4652"))
	titleFields.Text_winCount:setString(i18n("common_text_3364"))
	titleFields.Text_victory:setString(i18n("common_text_3403"))
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.Button_kingNumRule:setString(i18n("common_text_3366"))
	self.fields.Button_kingNumRule:addClickListener(handler(self, self.onClickBtnKingNumRule))
	self.fields.Button_scoreRule:setString(i18n("common_text_4653"))
	self.fields.Button_scoreRule:addClickListener(handler(self, self.onClickBtnScoreRule))
	self.fields.Button_winCountRule:setString(i18n("common_text_3365"))
	self.fields.Button_winCountRule:addClickListener(handler(self, self.onClickBtnWinCountRule))
	_UPVALUE5_ = self.fields.Button_winCountRule
	self.fields.Button_winCountRule[1] = self.fields.Text_victory
	self.fields.Button_winCountRule[2] = self.fields.Text_winCount
	self.fields.Button_winCountRule[3] = self.fields.Button_kingNumRule
	self.fields.Button_winCountRule[4] = self.fields.Button_scoreRule
	self.fields.Button_winCountRule[5] = self.fields.Button_winCountRule
	for i, v in ipairs(self.fields.Button_winCountRule) do
		v:fixPos()
	end
	self.fields.Com_rankTitle:fixChildrenPos()
end
function kingdomBattleHonourBoardPanel:onShow()
	print("=======kingdomBattleHonourBoardPanel:onShow")
	self.myKingDomNum = lordInfoCtrl:getMapSourceKid()
	SoraDShowLoading(self:displayObject())
	conquestWarCtrl:getHonorRankReq()
end
function kingdomBattleHonourBoardPanel:onRankItemRenderer(index, obj)
	local data = self.infoData[index + 1]
	if not obj.objFields then
		obj:fixChildrenPos()
		obj.objFields = fguiHelper.get_fields(obj)
		obj.objFields.Load_bg:fix()
		obj.controllers = fguiHelper.get_controllers(obj)
		if not SoraDFIsRA() then
			obj.objFields.Image_city:setPositionX(obj.objFields.Image_city:getPositionX() - 20)
		end
		obj.objFields.Image_city:addClickListener(handler(self, self.onClickBtnQuestion))
	end
	local objFields = obj.objFields
	local rank = data.rank
	if 0 < rank and rank <= 3 then
		obj.controllers.c_top3:setSelectedIndex(0)
		objFields.Load_rank:setURL(string.format("icon_ranking_%d.png", rank))
		objFields.Load_bg:setURL(string.format("frame_alliance_pank_%02d.png", rank))
	else
		obj.controllers.c_top3:setSelectedIndex(1)
		objFields.Text_rank:setString(tostring(rank))
		objFields.Load_bg:setURL("frame_alliance_pank_04.png")
	end
	if data.kid == self.myKingDomNum then
		objFields.Load_bg:setURL("frame_alliance_pank_05.png")
	end
	objFields.Image_city:setURL(kingdomCtrl:getKindomPalaceModelIcon(data.kid))
	objFields.Image_city:setTag(index + 1)
	objFields.Text_name:setString(data.kname)
	objFields.Text_score:setString(string.formatnumberthousands(data.score))
	objFields.Text_winCount:setString(string.formatnumberthousands(data.win))
	_ENV = string.formatnumberthousands(data.win)
	string.formatnumberthousands(data.win).num = math.floor(data.win / data.total * 100)
	string.formatnumberthousands(data.win).char = "%"
	objFields.Text_victory:setString(i18n("common_text_1470", string.formatnumberthousands(data.win)))
end
function kingdomBattleHonourBoardPanel:onClickBtnKingNumRule()
	SoraDPlaySound()
	self.sortType = "byKing"
	self:reSetData()
end
function kingdomBattleHonourBoardPanel:onClickBtnScoreRule()
	SoraDPlaySound()
	self.sortType = "byScore"
	self:reSetData()
end
function kingdomBattleHonourBoardPanel:onClickBtnWinCountRule()
	SoraDPlaySound()
	self.sortType = "byWin"
	self:reSetData()
end
function kingdomBattleHonourBoardPanel:initData(target, data)
	SoraDCloseLoading(self:displayObject())
	if data and data.data and next(data.data) then
		self.readyData = data.data
		self.infoData = self.proxy:sortByWin(self.readyData)
	else
		return
	end
	self:initView()
end
function kingdomBattleHonourBoardPanel:getMyKingInfo(...)
	local _ENV, oriInfo
	for _, v in pairs(self.readyData) do
		if v.kid == self.myKingDomNum then
			oriInfo = v
			break
		end
	end
	if next(oriInfo) then
		_ENV = nil
		_ENV = nil
		;(nil).num = string.format("%.1f", math.floor(oriInfo.win / oriInfo.total * 100))
		;(nil).char = "%"
		;(nil).gailv = i18n("common_text_1470", nil)
		self.fields.Text_victory:setString(i18n("common_text_3362", nil))
		_ENV = i18n("common_text_3362", nil)
		i18n("common_text_3362", nil).num = string.formatnumberthousands(oriInfo.win)
		self.fields.Text_winCount:setString(i18n("common_text_3363", i18n("common_text_3362", nil)))
	else
		_ENV = i18n("common_text_3363", i18n("common_text_3362", nil))
		i18n("common_text_3363", i18n("common_text_3362", nil)).gailv = i18n("common_text_3404")
		self.fields.Text_victory:setString(i18n("common_text_3362", i18n("common_text_3363", i18n("common_text_3362", nil))))
		_ENV = i18n("common_text_3362", i18n("common_text_3363", i18n("common_text_3362", nil)))
		i18n("common_text_3362", i18n("common_text_3363", i18n("common_text_3362", nil))).num = i18n("common_text_3404")
		self.fields.Text_winCount:setString(i18n("common_text_3363", i18n("common_text_3362", i18n("common_text_3363", i18n("common_text_3362", nil)))))
	end
end
function kingdomBattleHonourBoardPanel:reSetData(...)
	if next(self.readyData) then
		if "byKing" == self.sortType then
			self.infoData = self.proxy:sortByKing(self.readyData)
		elseif "byScore" == self.sortType then
			self.infoData = self.proxy:sortByScore(self.readyData)
		elseif "byWin" == self.sortType then
			self.infoData = self.proxy:sortByWin(self.readyData)
		end
	else
		return
	end
	self:initView()
end
function kingdomBattleHonourBoardPanel:initView()
	self:getMyKingInfo()
	self.fields.List_rank:setNumItems(#self.infoData)
end
function kingdomBattleHonourBoardPanel:onClickBtnQuestion(EventContext)
	local index = EventContext:getSender():getTag()
	conquestWarCtrl:reqKidBattleResult(self.infoData[index].kid)
	SoraDShowLoading(self:displayObject())
end
return kingdomBattleHonourBoardPanel
