local publicRead = include("publicRead")
local luckyFalconCtrl = SoraDGetCtrl("luckyFalconCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local luckyFalconRead = include("luckyFalconRead")
local luckyFalconView = class("luckyFalconView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("luckyFalconView")
	end
	return target
end)
function luckyFalconView:ctor()
	self:initControls()
	self:initSpineAnimation()
	self:initScroll()
end
function luckyFalconView:endShow()
	if SoraDGetCtrl("activityCenterUICtrl"):isHaveNewFlag(gActivityTimeActivityID.LUCKY_FALCON) then
		uiManager:show("luckyFalconAdditionalView")
	end
end
function luckyFalconView:activeTimeUp(dt)
	local height = self.Bottom_Size_ScrollView_btn:getContentSize().height
	local actMove1 = cca.moveTo(0.1, 55, not dt and self.Bottom_Size_ScrollView_btn:getPositionY() or self.Bottom_Size_ScrollView_btn:getPositionY() + 50)
	local actMove2 = cca.moveTo(0.1, 55, self.Bottom_Size_ScrollView_btn_circle:getPositionY() + 50)
	self.Bottom_Size_ScrollView_btn:stopAllActions()
	self.Bottom_Size_ScrollView_btn_circle:stopAllActions()
	self.Bottom_Size_ScrollView_btn:runAction(actMove1)
	self.Bottom_Size_ScrollView_btn_circle:runAction(actMove2)
	if self.Bottom_Size_ScrollView_btn:getPositionY() >= 348 + height then
		self.Bottom_Size_ScrollView_btn:setPositionY(self.Bottom_Size_ScrollView_btn_circle:getPositionY() - height)
	end
	if self.Bottom_Size_ScrollView_btn_circle:getPositionY() >= 348 + height then
		self.Bottom_Size_ScrollView_btn_circle:setPositionY(self.Bottom_Size_ScrollView_btn:getPositionY() - height)
	end
end
function luckyFalconView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LUCKY_FALCON_INIT", function(target, data)
		SoraDCloseLoading(self)
		if self.activeTimer then
			SoraDManagerRemoveTimer(self, self.activeTimer)
			self.activeTimer = nil
		end
		self:activeTimeUp()
		self.activeTimer = SoradCreateTimer(self, handler(self, self.activeTimeUp))
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_LUCKY_FALCON_ROTTERY_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		self = self
		self[1] = cca.delay(0.1)
		self[2] = cca.callFunc(function()
			local panel = SoraDCreatePanel("luckyFalconGetRewardView")
			panel:initData(data.rewardList, data.isFirstLottery)
			panel:show()
		end)
		self[3] = cca.callFunc(function()
			local panel = SoraDCreatePanel("luckyFalconGetRewardView")
			panel:initData(data.rewardList, data.isFirstLottery)
			panel:show()
		end)
		local seq = cca.seq(self)
		self:runAction(seq)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_LUCKY_FALCON_STAGE_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH", function(target, data)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_GET_EXTRA_SUCCESS", function(target, data)
		self:initData()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function luckyFalconView:initSpineAnimation()
	local filePath = "3d/card/falconHand.c3b"
	local eagle3D = cc.Sprite3D:create(filePath)
	if eagle3D == nil then
		return
	end
	_ENV = nil
	;(nil).x = 0
	;(nil).y = 0
	;(nil).z = 10
	eagle3D:setRotation3D(nil)
	eagle3D:setZ(500)
	eagle3D:setPosition(cc.p(530, 20))
	eagle3D:addTo(self.Bottom_Node, -1)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		local animate = cc.Animate3D:create(animation)
		eagle3D:runAction(cc.RepeatForever:create(animate))
	end
	eagle3D:setScale(13.0)
	_ENV = eagle3D.setScale
	eagle3D.setScale.file = "3d/card/falcon.c3b"
	eagle3D.setScale.shader = "3dColorTexAlphaCutout"
	eagle3D.setScale.vert = "Shaders/3dPositionTex.vsh"
	_ENV, _UPVALUE1_, eagle3D.setScale.frag = 13.0, eagle3D, "Shaders/3dColorTexAlphaCutout.fsh"
	;(13.0).name = "u_alpha"
	;(13.0).value = 0.5
	;(13.0).attr = "float"
	_ENV, eagle3D.setScale.shaderParam, eagle3D[1] = eagle3D, eagle3D, 13.0
	eagle3D.startFrame = 0
	_ENV, eagle3D.setScale.idle, eagle3D.endFrame = eagle3D, eagle3D, 40
	eagle3D.startFrame = 40
	eagle3D.setScale.show, eagle3D.endFrame = eagle3D, 108
	local eagle = eagle3D.setScale
	local eagle3D2 = cc.Sprite3D:create(eagle.file)
	_ENV = cc.RepeatForever:create(animate)
	cc.RepeatForever:create(animate).x = 0
	cc.RepeatForever:create(animate).y = 0
	cc.RepeatForever:create(animate).z = 10
	eagle3D2:setRotation3D(cc.RepeatForever:create(animate))
	eagle3D2:setPosition(cc.p(530, 20))
	eagle3D2:setZ(500)
	eagle3D2:addTo(self.Bottom_Node, -1)
	eagle3D2:setScale(13.0)
	self:loadShaderForSprite(eagle3D2, eagle.shader, eagle.shaderParam)
	eagle3D2:setCullFaceEnabled(false)
	local animation = cc.Animation3D:create(eagle.file)
	if nil ~= animation then
		local animate = cc.Animate3D:create(animation)
		eagle3D2:runAction(cc.RepeatForever:create(animate))
	end
end
function luckyFalconView:loadShaderForSprite(sprite3D, shaderName, shaderParam, subMesh)
	if G_IS_UNITY then
		return
	end
	local meshs = sprite3D:getMeshes()
	local shader = self:getOrCreateByShaderName(shaderName)
	local state = cc.GLProgramState:create(shader)
	for _, mesh in ipairs(meshs) do
		SoraDSetProgramStateParam(shader, state, shaderParam, mesh)
	end
	if not subMesh then
		sprite3D:setGLProgramState(state)
	else
		sprite3D:setGLProgramStateForMesh(state, subMesh)
	end
end
function luckyFalconView:getOrCreateByShaderName(shaderName)
	local SCM = require("app.shader.shader")
	local macco = "#define USE_SPECULAR_LIGHT"
	_ENV, _ENV = nil, nil
	;(nil).vert = "Shaders/3dPositionTex.vsh"
	_ENV, (nil)["3dColorTexAlphaCutout"], (nil).frag = nil, nil, "Shaders/3dColorTexAlphaCutout.fsh"
	;(nil).isByte = true
	;(nil).vert = macco .. SCM.simpleLightSkinnedVertBytes
	;(nil).SHADER_TYPE_SPECULAR_LIGHT, (nil).frag = nil, macco .. SCM.simpleLightFragBytes
	local shaderCfg
	local cfg = shaderCfg[shaderName] or shaderCfg["3dColorTexAlphaCutout"]
	local shaderCache = cc.GLProgramCache:getInstance()
	local shader = shaderCache:getGLProgram(shaderName)
	if not shader then
		if cfg.isByte then
			shader = cc.GLProgram:createWithByteArrays(cfg.vert, cfg.frag)
		else
			shader = cc.GLProgram:createWithFilenames(cfg.vert, cfg.frag)
		end
		shaderCache:addGLProgram(shader, shaderName)
	end
	return shader
end
function luckyFalconView:createVideoPlayer()
	local csbNode = display.getRunningScene()
	_ENV = nil
	;(nil).usmUrl = "eagleRottery.usm"
	;(nil).onCompleteFun = function(_video)
		print("==onCompleteFun==")
	end
	;(nil).onPanelClick = function(_video)
		print("==onPanelClick==")
	end
	;(nil).onStopfunc = function(_video)
		print("==onStopfunc==")
	end
	local (nil).needRemove, data = true, nil
	local videoPlayer = SoraDCreateVideoPlayerSingle(data)
	if videoPlayer then
		videoPlayer:play()
	end
end
function luckyFalconView:initYumaoEffect(parent)
	local effectym = SoraDCreatAnimation("xingyunlieyingjiangli", nil, false)
	effectym:setPosition(cc.p(display.width / 2, display.height / 2))
	self.Bottom_Node:addChild(effectym, 10)
end
function luckyFalconView:initJuanZhouEffect()
	local effectjz = SoraDCreatAnimation("juanzhou", nil, true)
	effectjz:setScale(0.95)
	effectjz:setPosition(cc.p(self.Button_pool_All:getContentSize().width / 2 - 5, self.Button_pool_All:getContentSize().height / 2 + 5))
	self.Button_pool_All:addChild(effectjz, 2)
end
function luckyFalconView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("activity_name_9001323"))
	self.activityID = gActivityTimeActivityID.LUCKY_FALCON
	self.activeTimer = nil
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.Text_time:setString(SoraDConvertSecondToString(leftTime))
		self.Text_time:beginTime(leftTime)
	end
	self.icon_hourglass_21:setPositionX(self.Text_time:getPositionX() - self.Text_time:getContentSize().width - 20)
	self.Text_remain:setString(i18n("luckyFalcon_text08"))
	_ENV = i18n("luckyFalcon_text08")
	i18n("luckyFalcon_text08").var = 1
	self.Text_one:setString(i18n("luckyFalcon_text13", i18n("luckyFalcon_text08")))
	self.Text_one_num:setString(1)
	_ENV = i18n("luckyFalcon_text13", i18n("luckyFalcon_text08"))
	i18n("luckyFalcon_text13", i18n("luckyFalcon_text08")).var = 10
	self.Text_ten:setString(i18n("luckyFalcon_text13", i18n("luckyFalcon_text13", i18n("luckyFalcon_text08"))))
	self.Text_ten_num:setString(9)
	self.Text_reward_preview:setString(i18n("Promise_Summit_text_41"))
	self.Text_reward_title:setString(i18n("decrypt_text_03"))
	self.btnHelpTip:addTouchEventListener(handler(self, self.buttonHelpCallBack))
	self.btn_add:addTouchEventListener(handler(self, self.btnAddCallBack))
	self.Button_one:addTouchEventListener(handler(self, self.btnOneCallBack))
	self.Button_ten:addTouchEventListener(handler(self, self.btnTenCallBack))
	self.btnPreview:addTouchEventListener(handler(self, self.btnStageCallBack))
	self.Button_pool_All:addTouchEventListener(handler(self, self.btnPoolRewardCallBack))
	self.costFalconNum = include("constantRead").getConstValue("LUCKY_FALCON_10ROW")
	self.discount = -(10 - self.costFalconNum) / 10 * 100 .. "%"
	self.Text_discount:setString(self.discount)
	self.frame_rechareactivity_hot_220:setVisible(10 - self.costFalconNum > 0)
	self.Text_discount:setVisible(10 - self.costFalconNum > 0)
	self.Button_pool_All:setTitleText(i18n("common_text_1720"))
	luckyFalconCtrl:reqInitInfo()
	SoraDShowLoading(self)
end
function luckyFalconView:fitDevice()
end
function luckyFalconView:initData()
	local itemCount = backpackCtrl:getItemCount(836101)
	local unGetRewardNum = luckyFalconCtrl:getUnGetStageRewardNum()
	self.Text_remain_num:setString(itemCount)
	self.Image_redPoint:setVisible(0 < unGetRewardNum)
	self.Text_remain_num:setPositionX(self.Image_gold_0:getPositionX() + self.Text_remain_num:getContentSize().width / 2 + 23)
	self.btn_add:setPositionX(self.Text_remain_num:getPositionX() + self.Text_remain_num:getContentSize().width / 2 + 30)
	self.Text_remain:setPositionX(self.Image_gold_0:getPositionX() - self.Text_remain:getContentSize().width / 2 - 14)
	if SoraDFIsRA() then
		self.Text_remain_num:setPositionX(self.Image_gold_0:getPositionX() - self.Text_remain_num:getContentSize().width / 2 - 23)
		self.btn_add:setPositionX(self.Text_remain_num:getPositionX() - self.Text_remain_num:getContentSize().width / 2 - 30)
		self.Text_remain:setPositionX(self.Image_gold_0:getPositionX() + self.Text_remain:getContentSize().width / 2 + 23)
	end
end
function luckyFalconView:buttonHelpCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "luckyFalcon_text04"
		;("luckyFalcon_text04").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("luckyFalcon_text04"), "luckyFalcon_text04")
	end
end
function luckyFalconView:initScroll()
	local classType = luckyFalconCtrl:getClassType()
	local showReward = luckyFalconRead.getPoolRewardOnShow(classType)
	self.Bottom_Size_ScrollView_btn:removeAllChildren()
	self.Bottom_Size_ScrollView_btn:setContentSize(cc.size(90, #showReward * 100))
	local sSize = self.Bottom_Size_ScrollView_btn:getContentSize()
	local sH = math.max(sSize.height, #showReward * 100)
	self.Bottom_Size_ScrollView_btn:setInnerContainerSize(cc.size(sSize.width, sH))
	for i, v in ipairs(showReward) do
		local cell = include("commonItemAward").new()
		cell:setPosition(sSize.width / 2, sH - (i - 1) * 100 - 40)
		cell:setScale(0.8)
		cell:setBaseScale(1.0)
		cell:setOwnView(self)
		cell:initData(v.id, v.count)
		cell:addTo(self.Bottom_Size_ScrollView_btn)
	end
	self.Bottom_Size_ScrollView_btn_circle:removeAllChildren()
	self.Bottom_Size_ScrollView_btn_circle:setContentSize(cc.size(90, #showReward * 100))
	self.Bottom_Size_ScrollView_btn_circle:setPositionY(self.Bottom_Size_ScrollView_btn:getPositionY() - sSize.height - 50)
	local sSize2 = self.Bottom_Size_ScrollView_btn_circle:getContentSize()
	local sH2 = math.max(sSize2.height, #showReward * 100)
	self.Bottom_Size_ScrollView_btn_circle:setInnerContainerSize(cc.size(sSize2.width, sH2))
	for i, v in ipairs(showReward) do
		local cell = include("commonItemAward").new()
		cell:setPosition(sSize2.width / 2, sH2 - (i - 1) * 100 - 40)
		cell:setScale(0.8)
		cell:setBaseScale(1.0)
		cell:setOwnView(self)
		cell:initData(v.id, v.count)
		cell:addTo(self.Bottom_Size_ScrollView_btn_circle)
	end
end
function luckyFalconView:btnAddCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		uiManager:show("luckyFalconBuyPackage")
	end
end
function luckyFalconView:btnPoolRewardCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("luckyFalconRewardDetailView")
		panel:show()
	end
end
function luckyFalconView:btnStageCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		uiManager:show("luckyFalconAdditionalView")
	end
end
function luckyFalconView:btnOneCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local itemCount = backpackCtrl:getItemCount(836101)
		if itemCount <= 0 then
			SoraDShowMsgBox(i18n("luckyFalcon_text10"), i18n("common_text_477"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					if tolua.isnull(self) then
						return
					end
					local packageList = self:getRightPackageID()
					if next(packageList) then
						if GLOBAL_GAME_RECHARGE_MODE then
							_ENV = nil
							;(nil).rechargeID = tonumber(packageList[1].ID)
							uiManager:show("rechargeView", nil)
						else
							local panel = SoraDCreatePanel("rechargeView")
							panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, tonumber(packageList[1].ID))
							panel:show()
						end
					elseif GLOBAL_GAME_RECHARGE_MODE then
						uiManager:show("rechargeView")
					else
						SoraDCreatePanel("rechargeView"):show()
					end
				end
			end)
			return
		end
		luckyFalconCtrl = i18n("luckyFalcon_text10")
		i18n("luckyFalcon_text10")[1] = cca.callFunc(function()
			self:createVideoPlayer()
		end)
		i18n("luckyFalcon_text10")[2] = cca.delay(4.5)
		i18n("luckyFalcon_text10")[3] = cca.callFunc(function()
			luckyFalconCtrl:reqLottery()
			SoraDShowLoading(self)
		end)
		i18n("luckyFalcon_text10")[4] = cca.callFunc(function()
			luckyFalconCtrl:reqLottery()
			SoraDShowLoading(self)
		end)
		local seq = cca.seq((i18n("luckyFalcon_text10")))
		self:runAction(seq)
	end
end
function luckyFalconView:btnTenCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local itemCount = backpackCtrl:getItemCount(836101)
		if itemCount < self.costFalconNum then
			SoraDShowMsgBox(i18n("luckyFalcon_text10"), i18n("common_text_477"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					local packageList = self:getRightPackageID()
					if next(packageList) then
						if GLOBAL_GAME_RECHARGE_MODE then
							_ENV = nil
							;(nil).rechargeID = tonumber(packageList[1].ID)
							uiManager:show("rechargeView", nil)
						else
							local panel = SoraDCreatePanel("rechargeView")
							panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, tonumber(packageList[1].ID))
							panel:show()
						end
					elseif GLOBAL_GAME_RECHARGE_MODE then
						uiManager:show("rechargeView")
					else
						SoraDCreatePanel("rechargeView"):show()
					end
				end
			end)
			return
		end
		luckyFalconCtrl = i18n("luckyFalcon_text10")
		i18n("luckyFalcon_text10")[1] = cca.callFunc(function()
			self:createVideoPlayer()
		end)
		i18n("luckyFalcon_text10")[2] = cca.delay(4.5)
		i18n("luckyFalcon_text10")[3] = cca.callFunc(function()
			luckyFalconCtrl:reqTenLottery()
			SoraDShowLoading(self)
		end)
		i18n("luckyFalcon_text10")[4] = cca.callFunc(function()
			luckyFalconCtrl:reqTenLottery()
			SoraDShowLoading(self)
		end)
		local seq = cca.seq((i18n("luckyFalcon_text10")))
		self:runAction(seq)
	end
end
function luckyFalconView:getRightPackageID()
	local activeDataList = clone(rechargeActivityCtrl:getRechargeActivityListByType(gRechargeActivityType.LIMIT_GIFT))
	local _ENV, tempList = rechargeActivityCtrl:getRechargeActivityListByType(gRechargeActivityType.LIMIT_GIFT)
	for i, v in ipairs(activeDataList) do
		if tonumber(v.ID) >= 14234 and tonumber(v.ID) <= 14237 and tonumber(v.extraData) > 0 then
			table.insert(tempList, v)
		end
	end
	table.sort(tempList, function(left, right)
		return tonumber(left.ID) < tonumber(right.ID)
	end)
	return tempList
end
function luckyFalconView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return luckyFalconView
