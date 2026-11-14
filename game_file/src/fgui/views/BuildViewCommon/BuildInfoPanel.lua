local WELevelProMin = 13
local WELevelProMax = 87
local maxDemolishNum = 10
local buildMoreInfoRead = include("buildMoreInfoRead")
local buildLogic = include("buildLogic")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local buildDescribeRead = include("buildDescribeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BuildInfoPanel = class("BuildInfoPanel", baseFguiPanel)
function BuildInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BuildInfoPanel:ctor", self.viewName)
end
function BuildInfoPanel:onInit()
	print("=======BuildInfoPanel:onInit")
	self.fields.ScrollView_info:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Label_title:setString(i18n("lordskill_name_12021"))
	self.spBrave = self.fields.sprite_Statue
	self.btnMore = self.fields.Button_more
	self.btnMore:setString(i18n("common_text_376"))
	self.btnMore:addClickListener(handler(self, self.btnMoreCallBack))
	self.btnCancel = self.fields.Button_cancel
	self.btnCancel:addClickListener(handler(self, self.btnCancelCallBack))
	self.btnCancelStar = self.fields.Button_cancelStar
	self.btnCancelStar:addClickListener(handler(self, self.btnCancelStarCallBack))
end
function BuildInfoPanel:onShow()
	print("=======BuildInfoPanel:onShow")
	_ENV = "=======BuildInfoPanel:onShow"
	;("=======BuildInfoPanel:onShow").isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI("=======BuildInfoPanel:onShow")
	self:initData(self.param.buildInfoData)
end
function BuildInfoPanel:initData(buildInfoData)
	self.tableBuildInfo = buildInfoData
	self:updateState()
	self.fields.Text_buildDes:setString(buildDescribeRead.getDes(self.tableBuildInfo.bid))
	local buildCell = cityCtrl:getBuildCell(self.tableBuildInfo.bid, self.tableBuildInfo.iid)
	local isWar, warLv, warCurPro = buildLogic.isBuildIDWarLv(self.tableBuildInfo.bid, buildCell.info.lv)
	buildDescribeRead = buildDescribeRead.getDes(self.tableBuildInfo.bid)
	buildDescribeRead.getDes(self.tableBuildInfo.bid).level = math.min(buildCell.info.lv, 30)
	local buildLv = i18n("common_text_420", buildDescribeRead.getDes(self.tableBuildInfo.bid))
	local isNeedShow = false
	if self.tableBuildInfo.buildEntity and (self.tableBuildInfo.buildEntity:getState() == "building" or self.tableBuildInfo.buildEntity:getIsTraining()) then
		if buildLogic.buildLvIsFull(self.tableBuildInfo.bid, self.tableBuildInfo.iid) then
			isNeedShow = false
		else
			isNeedShow = true
		end
	end
	if isWar and 0 <= warLv then
		self.warLv = warLv
		self.warCurPro = warCurPro
		self.warToLv = buildLogic.transformBuildLvToWarLv(buildCell.info.lv + 10)
		if 0 < warLv then
			buildDescribeRead = self.tableBuildInfo.iid
			self.tableBuildInfo.iid.lv = warLv
			buildLv = i18n("common_text_1948", self.tableBuildInfo.iid)
		end
		if isNeedShow then
			self:initWarView()
		end
	end
	self.starLv = tonumber(buildCell.info.starLv) or 0
	if 0 < self.starLv then
		buildDescribeRead = buildDescribeRead.getDes(self.tableBuildInfo.bid)
		buildDescribeRead.getDes(self.tableBuildInfo.bid).lv = self.starLv
		buildLv = buildLv .. "\n" .. i18n("Glory_text_24", buildDescribeRead.getDes(self.tableBuildInfo.bid))
	end
	if self.tableBuildInfo.bid == BUILDID.STAR_BRAVE_STATUE then
		self.controllers.c_type:setSelectedIndex(1)
		self.isHideCurrentSceneView = true
		self.fields.resourceMenu:updateResource()
		local quality, lv, starLv = SoraDGetBuildQuality()
		self.fields.Image_Down:setSpriteFrame(16 <= quality and "bg_ghyz_bj_new.png" or "bg_ghyz_bj.png")
		local cityltCtrl = include("cityltCtrl")
		self.fields.Com_name:setString(cityltCtrl.getStarBraveStatueLvStr(starLv))
		self.fields.Com_name:setPositionY(76)
		self.spBrave:initQuality(quality)
	else
		self.controllers.c_type:setSelectedIndex(0)
		self.fields.Com_name:setString(buildLv .. "\n" .. buildDescribeRead.getName(self.tableBuildInfo.bid))
	end
	if self.tableBuildInfo.bid == BUILDID.DEPOT then
		self.controllers.c_title:setSelectedIndex(1)
	else
		self.controllers.c_title:setSelectedIndex(0)
	end
	local buildInfo = buildMoreInfoRead.getInfoData(self.tableBuildInfo.bid, self.tableBuildInfo.iid)
	dump(buildInfo, "==buildInfo==")
	self.tableBuildInfo.buildInfo = buildInfo
	if #buildInfo == 0 then
		self.fields.Text_info:setVisible(true)
		self.fields.Text_info:setString(buildDescribeRead.getUpgradeDes(self.tableBuildInfo.bid))
	else
		self.fields.Text_info:setVisible(false)
		self:initScroll()
	end
	self:refreshCancelStarBtn()
	self:updateBtnPos()
end
function BuildInfoPanel:initWarView(...)
	self.fields.bar_war:setVisible(true)
	self.fields.Text_buildDes:setString(i18n("buildDes_upgrade_brief_301"))
	_ENV = i18n("buildDes_upgrade_brief_301")
	i18n("buildDes_upgrade_brief_301").warLv = self.warLv
	i18n("buildDes_upgrade_brief_301").warCurPro = self.warCurPro
	i18n("buildDes_upgrade_brief_301").warToLv = self.warToLv
	self.fields.bar_war:initData(i18n("buildDes_upgrade_brief_301"))
end
function BuildInfoPanel:updateState()
	self.btnCancel:setVisible(true)
	local viewState = self.tableBuildInfo.bstate
	if viewState == BUILD_STATE.NORMAL then
		local gQueueType = buildDescribeRead.getQueueType(self.tableBuildInfo.bid)
		if queueCtrl:queryQueue(gQueueType) and self.tableBuildInfo.bid ~= BUILDID.ELITE_PALACE then
			if queueCtrl:isHospitalQueue(gQueueType) then
				self.btnCancel:setTitleText(i18n("common_text_386"))
				self.tableBuildInfo.bstate = BUILD_STATE.TREATING
			elseif gQueueType == gQueueTypeDef.frotress_queue then
				self.btnCancel:setTitleText(i18n("common_text_384"))
				self.tableBuildInfo.bstate = BUILD_STATE.TRAP_BUILDING
			elseif gQueueType == gQueueTypeDef.chariot_plant_queue or gQueueType == gQueueTypeDef.stables_queue or gQueueType == gQueueTypeDef.range_queue or gQueueType == gQueueTypeDef.barracks_queue then
				self.btnCancel:setTitleText(i18n("common_text_383"))
				self.tableBuildInfo.bstate = BUILD_STATE.TRAINING
			elseif gQueueType == gQueueTypeDef.forge_equipment then
				self.btnCancel:setVisible(false)
				self.btnMore:setPositionX(320)
			elseif gQueueType == gQueueTypeDef.armor_forging then
				self.btnCancel:setTitleText(i18n("Soldiers_armor_text_46"))
				self.tableBuildInfo.bstate = BUILD_STATE.ARMORFORG
			elseif gQueueType == gQueueTypeDef.craft_study then
				self.btnCancel:setTitleText(i18n("Soldiers_armor_text_45"))
				self.tableBuildInfo.bstate = BUILD_STATE.CRAFT_STUDY
			else
				self.btnCancel:setTitleText(i18n("common_text_387"))
				self.tableBuildInfo.bstate = BUILD_STATE.STUDYING
			end
		elseif self.tableBuildInfo.btype == 0 then
			self.btnCancel:setVisible(false)
			self.btnMore:setPositionX(320)
		else
			local cityltCtrl = include("cityltCtrl")
			local isdemolish = cityltCtrl.buildAttr(self.tableBuildInfo.bid, BUILD_ATTR.ISDEMOLISH)
			if isdemolish == 0 then
				self.btnCancel:setVisible(false)
				self.btnMore:setPositionX(320)
			else
				self.btnCancel:setTitleText(i18n("common_text_728"))
			end
		end
	elseif viewState == BUILD_STATE.BUILDING then
		self.btnCancel:setTitleText(i18n("common_text_384"))
	elseif viewState == BUILD_STATE.UPGRADEING then
		self.btnCancel:setTitleText(i18n("common_text_385"))
	elseif viewState == BUILD_STATE.DEMOLISHING then
		self.btnCancel:setTitleText(i18n("common_text_727"))
	end
end
function BuildInfoPanel:initScroll()
	self.fields.ScrollView_info:setNumItems(#self.tableBuildInfo.buildInfo)
end
function BuildInfoPanel:onItemRenderer(index, obj)
	local data = self.tableBuildInfo.buildInfo[index + 1]
	obj:initData(data, self.tableBuildInfo.bid)
end
function BuildInfoPanel:btnMoreCallBack()
	SoraDPlaySound()
	local buildCell = cityCtrl:getBuildCell(self.tableBuildInfo.bid, self.tableBuildInfo.iid)
	_ENV = cityCtrl
	cityCtrl.isStar = self.tableBuildInfo.bid == BUILDID.STAR_BRAVE_STATUE
	cityCtrl.bid = self.tableBuildInfo.bid
	cityCtrl.blv = tonumber(buildCell.info.lv)
	local cityCtrl.starLv, buildInfo = tonumber(buildCell.info.starLv), cityCtrl
	_ENV = nil
	;(nil).buildInfo = buildInfo
	uiManager:show("BuildMoreInfo", nil)
end
function BuildInfoPanel:btnCancelCallBack()
	SoraDPlaySound()
	local viewState = self.tableBuildInfo.bstate
	if viewState == BUILD_STATE.NORMAL then
		if self.tableBuildInfo.bid == BUILDID.CASTLE then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_ENTER_MOVE_MODE"
			SoraDSendMessage(BUILDID.CASTLE)
			self:removeFromParent()
		else
			local cityCell = cityCtrl:getCurCity()
			local alreadyDemolishNum = cityCell.demolishInfo.count
			local remainNum = maxDemolishNum - alreadyDemolishNum
			if alreadyDemolishNum >= maxDemolishNum then
				SoraDShowMsgTip(i18n("Glory_text_60"))
			else
				_ENV = i18n("Glory_text_60")
				i18n("Glory_text_60").num = remainNum
				SoraDShowMsgBox(i18n("common_text_729", i18n("Glory_text_60")), i18n("common_text_204"), i18n("common_text_185"), function(callType)
					if callType == MSGBOX_CALLBACK_YES then
						local queueMastery = queueCtrl:queryQueue(gQueueTypeDef.build_mastery)
						if queueMastery and queueMastery.data.bid == self.tableBuildInfo.bid then
							SoraDShowMsgTip(i18n("specialization_tips_10"))
							return
						end
						local queue = queueCtrl:queryQueue(gQueueTypeDef.build_star_queue)
						if queue and queue.data.bid == self.tableBuildInfo.bid and queue.data.iid == self.tableBuildInfo.iid then
							SoraDShowMsgTip(i18n("Glory_text_50"))
							return
						end
						if tolua.isnull(self) then
							return
						end
						self:dismantleBuild(MSGBOX_CALLBACK_YES)
					end
				end)
			end
		end
	else
		local msgBox = "error"
		if viewState == BUILD_STATE.BUILDING or viewState == BUILD_STATE.TRAP_BUILDING then
			msgBox = i18n("common_text_730")
		elseif viewState == BUILD_STATE.UPGRADEING then
			msgBox = i18n("common_text_731")
		elseif viewState == BUILD_STATE.DEMOLISHING then
			msgBox = i18n("common_text_732")
		elseif viewState == BUILD_STATE.TREATING then
			msgBox = i18n("common_text_733")
		elseif viewState == BUILD_STATE.STUDYING then
			msgBox = i18n("common_text_734")
		elseif viewState == BUILD_STATE.TRAINING then
			msgBox = i18n("common_text_735")
		elseif viewState == BUILD_STATE.ARMORFORG then
			msgBox = i18n("Soldiers_armor_text_41")
		elseif viewState == BUILD_STATE.CRAFT_STUDY then
			msgBox = i18n("Soldiers_armor_text_39")
		end
		SoraDShowMsgBox(msgBox, i18n("common_text_054"), nil, handler(self, self.cancelQueue))
	end
end
function BuildInfoPanel:cancelQueue(type)
	if type == MSGBOX_CALLBACK_YES then
		local viewState = self.tableBuildInfo.bstate
		local msg
		if viewState == BUILD_STATE.BUILDING or viewState == BUILD_STATE.UPGRADEING then
			if BUILDID.NEBULA_PALACE == self.tableBuildInfo.bid then
				msg = i18n("nebula_war_text_0241")
			else
				msg = i18n("common_text_736")
			end
		elseif viewState == BUILD_STATE.DEMOLISHING then
			self:sureCancelQueue(type)
			return
		elseif viewState == BUILD_STATE.CRAFT_STUDY then
			msg = i18n("Soldiers_armor_text_40")
		elseif viewState == BUILD_STATE.ARMORFORG then
			msg = i18n("Soldiers_armor_text_38")
		elseif viewState == BUILD_STATE.STUDYING and BUILDID.MIRACLE == self.tableBuildInfo.bid then
			self:sureCancelQueue(type)
			return
		elseif viewState == BUILD_STATE.TREATING and BUILDID.HOSTPITAL == self.tableBuildInfo.bid then
			local queueType = buildDescribeRead.getQueueType(self.tableBuildInfo.bid)
			if queueType == gQueueTypeDef.radiance_war_hostpital_queue then
				msg = i18n("brightWar_text_171")
			elseif worldMapDefine.isInWar() then
				msg = i18n("atlantiswar_text_0001")
				if worldMapDefine.isInLegendLord() then
					msg = i18n("common_text_737")
				end
			else
				msg = i18n("common_text_737")
			end
		elseif BUILDID.NEBULA_PALACE == self.tableBuildInfo.bid then
			msg = i18n("nebula_war_text_0241")
		else
			msg = i18n("common_text_737")
		end
		SoraDShowMsgBox(msg, i18n("common_text_054"), nil, handler(self, self.sureCancelQueue))
	end
end
function BuildInfoPanel:sureCancelQueue(type)
	if type == MSGBOX_CALLBACK_YES then
		local viewState = self.tableBuildInfo.bstate
		local queueType
		if viewState == BUILD_STATE.BUILDING or viewState == BUILD_STATE.UPGRADEING or viewState == BUILD_STATE.DEMOLISHING then
			queueType = buildLogic.getQueueType(self.tableBuildInfo.bid, self.tableBuildInfo.iid)
			queueCtrl:cancelQueueReq(queueType)
		elseif viewState == BUILD_STATE.TREATING or viewState == BUILD_STATE.TRAP_BUILDING or viewState == BUILD_STATE.TRAINING or viewState == BUILD_STATE.ARMORFORG then
			queueType = buildDescribeRead.getQueueType(self.tableBuildInfo.bid)
			queueCtrl:cancelQueueReq(queueType)
		elseif viewState == BUILD_STATE.STUDYING or viewState == BUILD_STATE.CRAFT_STUDY then
			queueType = buildDescribeRead.getQueueType(self.tableBuildInfo.bid)
			local technologyCtrl = SoraDGetCtrl("technologyCtrl")
			technologyCtrl:cancleTechnology(queueType)
		end
		self:removeFromParent()
	end
end
function BuildInfoPanel:dismantleBuild(type)
	if type == MSGBOX_CALLBACK_YES then
		SoraDCheckSecondaryLock(function()
			local err, retdata = buildLogic.isCanDemolish(self.tableBuildInfo.bid, self.tableBuildInfo.iid)
			if err == gErrDef.Err_QUEUE_BUSY then
				SoraDShowMsgBox(i18n("common_text_708"), i18n("common_text_054"))
			elseif err == gErrDef.Err_CHARGE_QUEUE_TIME_NOT_REACH then
				local panel = SoraDCreatePanel("buildBuyBuilderPanel")
				panel:initData(retdata._demolishTime)
				panel:setHandle(function(type)
					if type == MSGBOX_CALLBACK_YES then
						self:dismantleBuild(type)
					end
				end)
				panel:show()
			elseif err == gErrDef.Err_BUILD_MASTERY_IS_UPGRADING then
				SoraDShowMsgTip(i18n("specialization_tips_10"))
			else
				local buildCell = cityCtrl:getBuildCell(self.tableBuildInfo.bid, self.tableBuildInfo.iid)
				local index = tonumber(buildCell.info.index)
				buildLogic.demolishBuild(index, retdata)
				cityCtrl:demolishBuildReq(index)
				buildLogic = cityCtrl
				cityCtrl.msg = "MESSAGE_MAINCITYVIEW_REMOVE_NPC_TOP_TIP"
				cityCtrl.bid = self.tableBuildInfo.bid
				cityCtrl.bIndex = index
				SoraDSendMessage(cityCtrl)
				buildLogic = cityCtrl
				cityCtrl.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
				cityCtrl.buildIndex = self.buildIndex
				SoraDSendMessage(cityCtrl)
				buildLogic = cityCtrl
				cityCtrl.msg = "MESSAGE_MAINCITYVIEW_DEMOLISH_BUILD"
				cityCtrl.index = index
				SoraDSendMessage(cityCtrl)
				self:removeFromParent()
			end
		end, gSecondaryLockType.DelBuilding, "BuildInfo")
	end
end
function BuildInfoPanel:btnCancelStarCallBack()
	SoraDPlaySound()
	local msgDes = i18n("Glory_text_39")
	if self.tableBuildInfo.bid == BUILDID.STAR_BRAVE_STATUE then
		msgDes = i18n("Soldiers_armor_text_37")
	end
	SoraDShowMsgBox(msgDes, i18n("common_text_054"), nil, handler(self, self.cancelStarQueue))
end
function BuildInfoPanel:cancelStarQueue(type)
	if type == MSGBOX_CALLBACK_YES then
		local msgDes = i18n("Glory_text_40")
		if self.tableBuildInfo.bid == BUILDID.STAR_BRAVE_STATUE then
			msgDes = i18n("Soldiers_armor_text_68")
		end
		SoraDShowMsgBox(msgDes, i18n("common_text_054"), nil, handler(self, self.sureCancelStarQueue))
	end
end
function BuildInfoPanel:sureCancelStarQueue(type)
	if type == MSGBOX_CALLBACK_YES then
		local queueType
		_UPVALUE3_ = nil
		;(nil)[1] = gQueueTypeDef.build_star_queue
		;(nil)[2] = gQueueTypeDef.build_star_queue_privilege
		;(nil)[3] = gQueueTypeDef.glorious_upgrade
		for _, _queueType in ipairs(nil) do
			local queue = queueCtrl:queryQueue(_queueType)
			if queue and tonumber(queue.data.bid) == self.tableBuildInfo.bid and queue.qtype then
				queueType = tonumber(queue.qtype)
				break
			end
		end
		queueCtrl:cancelQueueReq(queueType)
		self:removeFromParent()
	end
end
function BuildInfoPanel:refreshCancelStarBtn(...)
	local buildEntity = self.tableBuildInfo.buildEntity
	local buildStarState = tonumber(buildEntity:getBuildStarState())
	if buildStarState == BUILD_STAR_STATE.UPGRADEING then
		if self.tableBuildInfo.bid == BUILDID.STAR_BRAVE_STATUE then
			self.btnCancelStar:setTitleText(i18n("Soldiers_armor_btn_02"))
		else
			self.btnCancelStar:setTitleText(i18n("Glory_text_25"))
		end
		local viewState = self.tableBuildInfo.bstate
		if viewState == BUILD_STATE.NORMAL and self.tableBuildInfo.btype == 1 then
			self.btnCancel:setVisible(false)
		end
	else
		self.btnCancelStar:setVisible(false)
	end
end
function BuildInfoPanel:updateBtnPos(...)
	local _ENV, showList
	_UPVALUE3_ = nil
	;(nil)[1] = self.btnMore
	;(nil)[2] = self.btnCancel
	;(nil)[3] = self.btnCancelStar
	for __, btn in ipairs(nil) do
		if btn:isVisible() then
			table.insert(showList, btn)
		end
	end
	_UPVALUE3_ = (for generator)
	ipairs(nil)[1] = 216
	ipairs(nil)[2] = 72
	local ipairs(nil)[3], config = 6, ipairs(nil)
	local beginX = config[#showList] or 0
	local btnW = self.btnMore:getWidth()
	local stepX = 0
	if 1 < #showList then
		stepX = (640 - beginX * 2 - btnW) / (#showList - 1)
	end
	local offsetX = (self.view:getWidth() - 640) / 2
	beginX = beginX + offsetX
	for i, btn in ipairs(showList) do
		btn:setPositionX(beginX + (i - 1) * stepX)
		if SoraDFIsRA() then
			btn:fixPos(true)
		end
	end
end
function BuildInfoPanel:onHide()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_RECOVER
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI(nil)
end
function BuildInfoPanel:buildQueueCallback(target, data)
	local optype = data.optype
	local bid = data.bid
	local iid = data.iid
	if bid == self.tableBuildInfo.bid and (self.tableBuildInfo.iid == iid or iid == nil) then
		if optype and (optype == QUEUE_OPERATE_TYPE.CANCLE or optype == BUILD_OPERATE_TYPE.DEMOLISH) then
			self:removeFromParent()
		else
			SoraDRemoveAllExceptPanelFromManager(self)
			self.tableBuildInfo.bstate = BUILD_STATE.NORMAL
			self:initData(self.tableBuildInfo)
		end
	end
end
function BuildInfoPanel:closeByBuildLock()
	if self.tableBuildInfo.buildEntity and self.tableBuildInfo.buildEntity:getIsLocked() then
		SoraDRemoveAllPanelFromManager()
	end
end
return BuildInfoPanel
