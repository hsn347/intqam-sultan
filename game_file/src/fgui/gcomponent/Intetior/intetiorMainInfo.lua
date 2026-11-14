local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local baseComponent = require("fgui.base.baseComponent")
local intetiorMainInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/intetiorMainInfo", intetiorMainInfo)
local MAX_REQ_NUM = 3
function intetiorMainInfo:onInit()
	_UPVALUE6_, self.listData_Trick, _ENV, self.listData_Doate, _ENV, self.sIndex = nil, nil, nil, nil, nil, 1
	self.resType, (nil)[1] = nil, gIDDef.FOOD
	self.resType, (nil)[2] = nil, gIDDef.WOOD
	self.resType, (nil)[3] = nil, gIDDef.IRON
	self.resType, (nil)[4] = nil, gIDDef.MITHRIL
	self.resType, (nil)[5] = nil, gIDDef.CRYSTAL
	self.resType, (nil)[6] = nil, gIDDef.GOLDBAR
	self.fields.Button_log_more:addClickListener(handler(self, self.onClickLogMore))
	self.fields.Button_donate:addClickListener(handler(self, self.onClickDonate))
	self.fields.Button_trick:addClickListener(handler(self, self.onClickTrick))
	self.fields.Button_save:addClickListener(handler(self, self.btnSaveClickCallBack))
	self.fields.Button_edit:addClickListener(handler(self, self.btnEditClickCallBack))
	self.fields.Button_rank:addClickListener(handler(self, self.onClickRank))
	self.fields.Button_allocation:addClickListener(handler(self, self.onClickAllocation))
	self.fields.Button_allocation:setTitleText(i18n("common_text_1441"))
	self.fields.Button_donate:setTitleText(i18n("parliament_btn_13"))
	self.fields.Button_trick:setTitleText(i18n("parliament_btn_14"))
	self.fields.Button_save:setTitleText(i18n("common_text_195"))
	self.fields.Text_edit:setString(i18n("parliament_btn_09"))
	self.fields.Text_title_name:setString(i18n("parliament_btn_07"))
	self.fields.Button_log_more:setString("···")
	self.fields.text_tips:setString(i18n("common_text_927"))
	self.fields.Com_head:setHandle(handler(self, self.onClickBtnKing))
	self.fields.List_Log:setItemRenderer(handler(self, self.onItemLogRender))
	local posY = self.fields.List_Log:getPositionY()
	self.fields.List_Log:setContentSize(cc.size(640, self:getHeight() - posY - 153))
	self.fields.List_Res:setItemRenderer(handler(self, self.onItemResRender))
end
function intetiorMainInfo:onShow()
	self:reqSendMsg(self.sIndex)
	self:updateKing()
	self:updateResourceInfo()
end
function intetiorMainInfo:reqSendMsg(index)
	intetiorCtrl:reqParliamentTreasuryData()
	intetiorCtrl:reqParliamentTreasuryDonateRecord(index, MAX_REQ_NUM)
	intetiorCtrl:reqParliamentTrickStealRecord(index, MAX_REQ_NUM)
end
function intetiorMainInfo:updateKing()
	local kid = gametop.playertop_:getKingdomID()
	local kingData = KWKingdomCtrl:getKingInfo(kid)
	if kingData.kingUid and kingData.kingUid > 0 then
		if kingData.kingAbbr then
			self.fields.text_alliance:setString(kingData.kingAbbr)
		else
			self.fields.text_alliance:setString(i18n("common_text_480"))
		end
		self.fields.text_name:setString(kingData.kingName)
		self.fields.Com_head:getLoadHead():setVisible(true)
		self.fields.Com_head:setHeadSprite(kingData.kingIcon, kingData.kingAvatar)
	else
		local txtTips = i18n("common_text_480")
		self.fields.text_alliance:setString(txtTips)
		self.fields.text_name:setString(txtTips)
		self.fields.Com_head:getLoadHead():setVisible(false)
	end
	self.fields.Button_allocation:setVisible(SoraDIsSelfKing())
	local edict = intetiorCtrl:getIntetiorEdict()
	if edict and 0 < string.len(edict) then
		self.fields.Text_slogan:setString(edict)
	else
		self.fields.Text_slogan:setString(i18n("parliament_text_10"))
	end
	local isCanEdict = intetiorCtrl:isCanEdict()
	self.fields.Button_edit:setVisible(isCanEdict)
end
function intetiorMainInfo:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", handler(self, self.updateKing))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TREASURY_DONATE_RECORD", handler(self, self.initData_Doate))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_TRICK_STEAL_RECORD", handler(self, self.initData_Trick))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.msgGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_RESOURCE_DATA", handler(self, self.updateResourceInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_GOLD_BAR_KINGDOM_CHANGE", handler(self, self.updateResourceInfo))
end
function intetiorMainInfo:onClickLogMore()
	SoraDPlaySound()
	uiManager:show("intetiorResourceRecord")
end
function intetiorMainInfo:onClickDonate()
	SoraDPlaySound()
	uiManager:show("intetiorDonateGold")
end
function intetiorMainInfo:onClickTrick()
	SoraDPlaySound()
	uiManager:show("intetiorTrick")
end
function intetiorMainInfo:onClickBtnKing()
	local kid = gametop.playertop_:getKingdomID()
	local kingData = KWKingdomCtrl:getKingInfo(kid)
	if kingData.kingUid and kingData.kingUid > 0 then
		SoraDPlaySound()
		local uid = kingData.kingUid
		self:reqPlayerInfo(uid, kid)
	end
end
function intetiorMainInfo:reqPlayerInfo(uid, kid)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local key = "fromIntetior"
	gametop = nil
	;(nil)[key] = true
	;(nil).targetName = key
	lordInfoCtrl:getLordInfoByUid(uid, kid, nil)
end
function intetiorMainInfo:btnEditClickCallBack()
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(1)
	local edict = intetiorCtrl:getIntetiorEdict()
	if edict and string.len(edict) > 0 then
		self.fields.Input_slogan:setPromptHolder(self.fields.Text_slogan:getText(), "#4E3800")
	else
		self.fields.Input_slogan:setPromptHolder(i18n("parliament_text_10"), "#4E3800")
	end
end
function intetiorMainInfo:btnSaveClickCallBack()
	SoraDPlaySound()
	local showMsg = i18n("parliament_text_146")
	SoraDShowMsgBox(showMsg, i18n("common_text_054"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
			self.controllers.c1:setSelectedIndex(0)
			local str = self.fields.Input_slogan:getText()
			if str and 0 < string.len(str) then
				self.fields.Text_slogan:setString(str)
				intetiorCtrl:reqParliamentTreasuryModifyEdict(str)
			end
		end
	end)
end
function intetiorMainInfo:onClickRank()
	SoraDPlaySound()
	uiManager:show("intetiorDonateRank")
end
function intetiorMainInfo:onClickAllocation()
	SoraDPlaySound()
	if not SoraDIsSelfKing() then
		SoraDShowMsgTip(i18n("parliament_text_07"))
		return
	end
	if intetiorCtrl:getAllocationLeftCDTime() > 0 then
		SoraDShowMsgTip(i18n("parliament_text_128"))
		return
	end
	uiManager:show("IntetiorAllocation")
end
function intetiorMainInfo:updateResourceInfo()
	self.tableRescources = intetiorCtrl:getKingdomResource()
	self.fields.List_Res:setNumItems(#self.resType)
end
function intetiorMainInfo:msgGetLordInfo(target, data)
	if data.clientData then
		local keyName = "fromIntetior"
		local keyValue = data.clientData[keyName]
		if keyValue == true then
			SoraDOpenLordView(data.lord)
		end
	end
end
function intetiorMainInfo:initData_Trick(target, data)
	SoraDCloseLoading(self)
	local deal, dealTable = self:initData_imp(data, self.listData_Doate, 1)
	if deal then
		self.listData_Trick = dealTable
	end
end
function intetiorMainInfo:initData_Doate(target, data)
	SoraDCloseLoading(self)
	local deal, dealTable = self:initData_imp(data, self.listData_Trick, 2)
	if deal then
		self.listData_Doate = dealTable
	end
end
function intetiorMainInfo:initData_imp(data, listDataOther, dataType)
	if data.iBegin and data.iBegin == 1 then
		if not data.rankList then
			local _ENV, rankList = data.rankList, data.rankList
		end
		if next(rankList) ~= nil then
			local _ENV, listData = next(rankList), next(rankList)
			local tableMerge = clone(listDataOther)
			for i = 1, MAX_REQ_NUM do
				local v = rankList[i]
				if v then
					v.dataType = dataType
					listData[i] = v
					tableMerge[#tableMerge + 1] = v
				else
					break
				end
			end
			table.sort(tableMerge, function(a, b)
				return b.t < a.t
			end)
			local _ENV, showList = table.sort, table.sort
			for i = 1, MAX_REQ_NUM do
				local v = tableMerge[i]
				if v then
					showList[#showList + 1] = v
				else
					break
				end
			end
			self:initData(showList)
			return true, listData
		end
	end
	return false
end
function intetiorMainInfo:initData(data)
	self:clearListData()
	_UPVALUE0_ = nil
	;(nil).rankList = data
	;(nil).wGet = false
	self:initScrollData(nil)
end
function intetiorMainInfo:clearListData()
	self.rankData, _UPVALUE0_ = nil, nil
	self.sIndex = 1
	self.wGet = false
end
function intetiorMainInfo:initScrollData(data)
	dump(data, "data", 10)
	if not data.rankList then
		local _ENV, rankList = data.rankList, data.rankList
	end
	local num = #rankList
	self.sIndex = self.sIndex + #rankList
	if data.wGet ~= nil then
		self.wGet = data.wGet
	else
		self.wGet = num >= MAX_REQ_NUM
	end
	if next(rankList) ~= nil then
		local cpyTbl = clone(rankList)
		for _, v in ipairs(cpyTbl) do
			table.insert(self.rankData, v)
		end
	end
	self:initScrollView()
end
function intetiorMainInfo:initScrollView()
	if #self.rankData <= 0 then
		self.fields.text_tips:setVisible(true)
		self.fields.List_Log:setVisible(false)
	else
		self.fields.text_tips:setVisible(false)
		self.fields.List_Log:setVisible(true)
		self.fields.List_Log:setNumItems(#self.rankData)
	end
end
function intetiorMainInfo:onItemLogRender(index, target)
	target:initData(self.rankData[index + 1], index)
end
function intetiorMainInfo:onItemResRender(index, target)
	local type = self.resType[index + 1]
	target:setString(SoraDConvertNumberWithUnit(self.tableRescources[tostring(type)] or 0))
	target:getController("c1"):setSelectedIndex(index)
	target:fixChildrenPos()
end
return intetiorMainInfo
