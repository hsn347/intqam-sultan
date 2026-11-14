local gametop = gModuleMgr.getObject("gametop")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local allianceDesRead = include("allianceDesRead")
local AllianceRelationApplyView = class("allianceRelationApplyView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceRelationApplyView")
	end
	return target
end)
function AllianceRelationApplyView:ctor()
	_UPVALUE2_, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.tableCheck, _ENV, self.tableRelation, _ENV, self.tableDes, SoraDGetChildByName(self, "Center_Node")[1] = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), i18n("common_text_3083")
	self.tableCheck, _ENV, self.tableRelation, _ENV, self.tableDes, SoraDGetChildByName(self, "Center_Node")[2] = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), i18n("common_text_3084")
	self.tableCheck, _ENV, self.tableRelation, _ENV, self.tableDes, SoraDGetChildByName(self, "Center_Node")[3] = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), i18n("common_text_3085")
	self.tableCheck, _ENV, self.tableRelation, _ENV, self.tableDes, SoraDGetChildByName(self, "Center_Node")[4] = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), i18n("common_text_3085")
	self.tableCheck, _ENV, self.tableRelation, _ENV, self.tableDes, SoraDGetChildByName(self, "Center_Node")[5] = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), i18n("common_text_3085")
	self.tableCheck, _ENV, self.tableRelation, _ENV, self.tableDes, SoraDGetChildByName(self, "Center_Node")[6] = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), i18n("common_text_3085")
	self.tableCheck, _ENV, self.tableRelation, _ENV, self.tableDes, SoraDGetChildByName(self, "Center_Node")[7] = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), i18n("common_text_3085")
	self.tableCheck, _ENV, self.tableRelation, _ENV, self.tableDes, SoraDGetChildByName(self, "Center_Node")[8] = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), i18n("common_text_3085")
	self.tableCheck, _ENV, self.tableRelation, _ENV, self.tableDes, SoraDGetChildByName(self, "Center_Node")[9] = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), i18n("common_text_3085")
	self.tableAlliacnePoint = nil
	self.oldType = nil
	self.curCheck = nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.btnApply = SoraDGetChildByName(self, "Button_apply")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.tableRelation = SoraDGetChildsArrayByName(self, "Image_relation_", 5, 1)
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.btnApply:addTouchEventListener(handler(self, self.btnClickCallBack))
	if worldMapDefine.isInWarForbid(true) then
		self.btnApply:setBright(false)
	end
	for i, v in ipairs(self.tableRelation) do
		table.insert(self.tableCheck, SoraDGetChildByName(v, "CheckBox_choice"))
		self.tableCheck[i]:addTouchEventListener(handler(self, self.btnChioceClickCallBack))
	end
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE", function(target, data)
		SoraDCloseLoading(self)
		local curType = data.curType
		if data.err == gErrDef.Err_None then
			if curType == gAllianceRelationType.ALLY then
				self:removeFromParent()
				return
			elseif curType and self.tableAlliacnePoint then
				local relation = curType == gAllianceRelationType.FRIENDLY and i18n("common_text_3077") or i18n("common_text_3078")
				_ENV = nil
				_ENV = nil
				;(nil).abbr = self.tableAlliacnePoint:getProperty("abbr")
				;(nil).name = self.tableAlliacnePoint:getProperty("name")
				;(nil).alliance = i18n("common_text_186", nil)
				;(nil).relation = relation
				SoraDShowMsgTip(i18n("common_text_3082", nil))
			end
			self:removeFromParent()
		end
	end)
end
function AllianceRelationApplyView:initData(data)
	if data then
		self.tableAlliacnePoint = data
		self.oldType = allianceRelationCtrl:getRelationTypeWith(self.tableAlliacnePoint:getProperty("aid"))
		self:showApply(self.oldType)
	else
		self:showHelp()
	end
end
function AllianceRelationApplyView:setCheck(btn, check)
	if check then
		if self.curCheck then
			self.curCheck:setSelected(false)
			self.curCheck:setTouchEnabled(true)
		end
		self.curCheck = btn
		local tag = self.curCheck:getTag()
		self.labelNotice:setString(self.tableDes[tag])
		self.btnApply:setTitleText(tag == gAllianceRelationType.ALLY and i18n("common_text_182") or i18n("common_text_204"))
	end
	btn:setSelected(check)
	btn:setTouchEnabled(not check)
end
function AllianceRelationApplyView:showApply(rtype)
	_ENV, _ENV = nil, nil
	;(nil).color = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.ALLY)
	_ENV, (nil)[1], (nil).name = nil, nil, i18n("common_text_3076")
	;(nil).color = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.FRIENDLY)
	_ENV, (nil)[2], (nil).name = nil, nil, i18n("common_text_3077")
	;(nil).color = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.ENEMY)
	;(nil)[3], (nil).name = nil, i18n("common_text_3078")
	local showData
	self.labelNotice:setString("")
	for i, v in ipairs(self.tableRelation) do
		if showData[i] then
			local labelRelation = SoraDGetChildByName(v, "Text_relation")
			local imgColor = SoraDGetChildByName(v, "Image_color")
			labelRelation:setString(showData[i].name)
			imgColor:setColor(showData[i].color)
			self.tableCheck[i]:setTag(i)
			if rtype and rtype == i then
				self:setCheck(self.tableCheck[i], true)
			else
				self:setCheck(self.tableCheck[i], false)
			end
		else
			v:setVisible(false)
		end
	end
	self.ccs_bg:setTitleName(i18n("common_text_3103"))
	self.labelNotice:setVisible(true)
	self.btnApply:setTitleText(rtype == gAllianceRelationType.ALLY and i18n("common_text_182") or i18n("common_text_204"))
	local relation = rtype == nil and i18n("common_text_3104") or showData[rtype].name
	_ENV = i18n("common_text_3103")
	_ENV = i18n("common_text_3103")
	i18n("common_text_3103").abbr = self.tableAlliacnePoint:getProperty("abbr")
	i18n("common_text_3103").name = self.tableAlliacnePoint:getProperty("name")
	i18n("common_text_3103").alliance = i18n("common_text_186", i18n("common_text_3103"))
	i18n("common_text_3103").relation = relation
	self.labelDes:setString(i18n("common_text_3082", i18n("common_text_3103")))
end
function AllianceRelationApplyView:showHelp()
	_ENV, _ENV = nil, nil
	;(nil).color = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.ALLY)
	_ENV, (nil)[1], (nil).name = nil, nil, i18n("common_text_3076")
	;(nil).color = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.FRIENDLY)
	_ENV, (nil)[2], (nil).name = nil, nil, i18n("common_text_3077")
	;(nil).color = worldMapDefine.getLeagueManorLineColor(false, gMapAllianceRelationType.ENEMY)
	;(nil)[3], (nil).name = nil, i18n("common_text_3078")
	local showData
	local interval = 75
	local beginY = interval * (#showData / 2 - 0.5) + 5
	for i, v in ipairs(self.tableRelation) do
		if showData[i] then
			v:setPositionY(beginY - interval * (i - 1))
			local labelRelation = SoraDGetChildByName(v, "Text_relation")
			local imgColor = SoraDGetChildByName(v, "Image_color")
			labelRelation:setString(showData[i].name)
			imgColor:setColor(showData[i].color)
			self.tableCheck[i]:setVisible(false)
		else
			v:setVisible(false)
		end
	end
	self.ccs_bg:setTitleName(i18n("common_text_3102"))
	self.labelDes:setString(i18n("common_text_3080"))
	self.labelNotice:setVisible(false)
	self.btnApply:setTitleText(i18n("common_text_204"))
end
function AllianceRelationApplyView:btnChioceClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self:setCheck(button, true)
	end
end
function AllianceRelationApplyView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isInWarForbid() then
			return
		end
		if self.labelNotice:isVisible() then
			if self.curCheck then
				local tag = self.curCheck:getTag()
				if tag ~= self.oldType then
					if allianceDesRead.checkRank(gAllianceRank.R4, true) then
						local aid = self.tableAlliacnePoint:getProperty("aid")
						if tag == gAllianceRelationType.ALLY then
							if allianceRelationCtrl:getAR():getRelationNum(gAllianceRelationType.ALLY) > ALLIANCE_RELATION_ALLY_MAX then
								SoraDShowMsgTip(i18n("common_text_3086"))
							elseif allianceRelationCtrl:getAR():getSendInviteNum() >= ALLIANCE_RELATION_ALLY_INVITE_SEND_MAX then
								SoraDShowMsgTip(i18n("common_text_3089"))
							elseif allianceRelationCtrl:getAR():getSendInvite(aid) then
								SoraDShowMsgTip(i18n("common_text_3113"))
							else
								allianceRelationCtrl:reqInviteAllyAlliance(aid)
								SoraDShowLoading(self)
							end
						elseif tag == gAllianceRelationType.FRIENDLY then
							if allianceRelationCtrl:getAR():getAlterCount() >= ALLIANCE_RELATION_TOTAL_ALTER_DAY_MAX then
								SoraDShowMsgTip(i18n("common_text_3091"))
							else
								allianceRelationCtrl:reqAddFriendlyAlliance(aid)
								SoraDShowLoading(self)
							end
						elseif tag == gAllianceRelationType.ENEMY then
							if allianceRelationCtrl:getAR():getAlterCount() >= ALLIANCE_RELATION_TOTAL_ALTER_DAY_MAX then
								SoraDShowMsgTip(i18n("common_text_3091"))
							else
								allianceRelationCtrl:reqAddEnemyAlliance(aid)
								SoraDShowLoading(self)
							end
						end
					end
				else
					SoraDShowMsgTip(i18n("common_text_3105"))
				end
			end
		else
			self:close(button, type)
		end
	end
end
return AllianceRelationApplyView
