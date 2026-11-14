local equipmentltCtrl = include("equipmentltCtrl")
local itemDesRead = include("itemDesRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local equipmentCtrl = gametop.playertop_:getModule("equipmentCtrl")
local MaterialsCompoundView = class("materialsCompoundView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("materialsCompoundView")
	end
	return target
end)
function MaterialsCompoundView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node_bg")
	self.curMid = nil
	_ENV, self.tableArrowOpacity, _ENV, self.chainPos, _ENV, self.tableMaterialData, _ENV, self.tableMaterialSinge, _ENV, self.tableSpriteLace, _ENV, self.toMid = SoraDGetChildByName(self, "Center_Node_bg"), SoraDGetChildByName(self, "Center_Node_bg"), SoraDGetChildByName(self, "Center_Node_bg"), SoraDGetChildByName(self, "Center_Node_bg"), SoraDGetChildByName(self, "Center_Node_bg"), SoraDGetChildByName(self, "Center_Node_bg"), SoraDGetChildByName(self, "Center_Node_bg"), SoraDGetChildByName(self, "Center_Node_bg"), SoraDGetChildByName(self, "Center_Node_bg"), SoraDGetChildByName(self, "Center_Node_bg"), SoraDGetChildByName(self, "Center_Node_bg"), nil
	SoraDGetChildByName(self, "Center_Node_bg")[1] = SoraDGetChildByName(self, "Sprite_arrow_1")
	SoraDGetChildByName(self, "Center_Node_bg")[2] = SoraDGetChildByName(self, "Sprite_arrow_2")
	self.tableArrow, SoraDGetChildByName(self, "Center_Node_bg")[3] = SoraDGetChildByName(self, "Center_Node_bg"), SoraDGetChildByName(self, "Sprite_arrow_3")
	for i, v in ipairs(self.tableArrow) do
		table.insert(self.tableArrowOpacity, v:getOpacity() / 255)
	end
	self.Node_mergeEffect = SoraDGetChildByName(self, "Node_mergeEffect")
	self.Node_from = SoraDGetChildByName(self.Node_mergeEffect, "Node_from")
	self.Node_mid = SoraDGetChildByName(self.Node_mergeEffect, "Node_mid")
	self.Node_mid:setVisible(false)
	_ENV, _ENV = self.Node_mid, self.Node_mid.setVisible
	self.Node_mid.line = SoraDGetChildByName(self.Node_mid, "dh_zhuangbeihc_1")
	_ENV, self.Node_mid.setVisible[1], self.Node_mid.delay = self.Node_mid, self.Node_mid, 1
	self.Node_mid.line = SoraDGetChildByName(self.Node_mid, "dh_zhuangbeihc_2")
	_ENV, self.Node_mid.setVisible[2], self.Node_mid.delay = self.Node_mid, self.Node_mid, 8
	self.Node_mid.line = SoraDGetChildByName(self.Node_mid, "dh_zhuangbeihc_3")
	_ENV, self.Node_mid.setVisible[3], self.Node_mid.delay = self.Node_mid, self.Node_mid, 4
	self.Node_mid.line = SoraDGetChildByName(self.Node_mid, "dh_zhuangbeihc_4")
	self.tableLine, self.Node_mid.setVisible[4], self.Node_mid.delay = self.Node_mid.setVisible, self.Node_mid, 10
	local frames = display.newFrames("dh_zhuangbeihc_%.2d.png", 1, 9)
	local animation = display.newAnimation(frames, 0.03333333333333333)
	display.setAnimationCache("mergeAnimation", animation)
	self.Node_to = SoraDGetChildByName(self.Node_mergeEffect, "Node_to")
	SoraDStopEffectNode(self.Node_to)
	SoraDStopEffectNode(self.Node_mid)
	SoraDStopEffectNode(self.Node_from)
	self.centerNodeBg = SoraDGetChildByName(self, "Center_Node_bg")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self.centerNodeBg, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_1352"))
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelDes:setString(i18n("common_text_1379"))
	self.btnCompound = SoraDGetChildByName(self, "Button_compound")
	self.btnCompound:setTitleText(i18n("common_text_1352"))
	self.btnCompoundAll = SoraDGetChildByName(self, "Button_compoundAll")
	self.btnCompoundAll:setTitleText(i18n("common_text_1754"))
	self.btnCompound:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnCompoundAll:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.tableMaterialSinge = SoraDGetChildsArrayByName(self, "CCS_commonItemAward_", 4, 1, true, true)
	self.lineLight = display.newSprite("#frame_goods_01.png")
	self.lineLight:setVisible(false)
	self.lineLight:setScale(1.2)
	self.lineLight:setPosition(cc.p(0, 0))
	self.lineLight:retain()
	self.materialFrom = SoraDGetExtendChildFromCCSByName(self, "CCS_materialSingle_from")
	self.materialTo = SoraDGetExtendChildFromCCSByName(self, "CCS_materialSingle_to")
	self:addMergeEffect()
end
function MaterialsCompoundView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_METERIAL_MERGE_BACK", function(...)
		self:initData(self.curMid, true)
	end)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(...)
		if SoraDCurrentTopPanelFromManager() ~= self then
			self:initData(self.curMid)
		end
	end)
end
function MaterialsCompoundView:initData(mid, isShowEffect)
	self.curMid = mid
	self.toMid = equipmentltCtrl.getMaterialIDAfterMerge(self.curMid)
	local tableM = equipmentltCtrl.getMaterialList(equipmentltCtrl.getMaterialType(self.curMid))
	self.tableMaterialData, equipmentltCtrl = equipmentltCtrl.getMaterialType(self.curMid)
	for i, v in ipairs(tableM) do
		local count = backpackCtrl:getItemCount(v)
		equipmentltCtrl = equipmentltCtrl.getMaterialType(self.curMid)
		equipmentltCtrl.getMaterialType(self.curMid).mid = v
		equipmentltCtrl.getMaterialType(self.curMid).num = count
		table.insert(self.tableMaterialData, equipmentltCtrl.getMaterialType(self.curMid))
	end
	if isShowEffect then
		self:showMergeEffect()
	else
		self:initView()
	end
end
function MaterialsCompoundView:showMergeEffect()
	local lineAct = function()
		for k, v in ipairs(self.tableLine) do
			v.line:setVisible(false)
			_UPVALUE3_ = nil
			;(nil)[1] = cca.delay(v.delay / 60)
			;(nil)[2] = cca.callFunc(function()
				v.line:setVisible(true)
				v.line:playAnimationOnce(display.getAnimationCache("mergeAnimation"))
			end)
			;(nil)[3] = cca.delay(0.3)
			;(nil)[4] = cca.callFunc(function()
				v.line:setVisible(false)
			end)
			;(nil)[5] = cca.callFunc(function()
				v.line:setVisible(false)
			end)
			v.line:runAction(cca.seq(nil))
		end
	end
	local showTip = function()
		local name = itemDesRead.getName(self.toMid)
		local color = itemDesRead.getColor(self.toMid)
		itemDesRead = nil
		itemDesRead = nil
		;(nil).mname = name
		;(nil).text = i18n("common_text_1405", nil)
		;(nil).color = color
		;(nil).size = 20
		local materialLabel = display.newTTFLabel(nil)
		materialLabel:addTo(self, 99)
		materialLabel:setPosition(cc.p(320, 532))
		_ENV = materialLabel
		self = cc.p(320, 532)
		cc.p(320, 532)[1] = cca.moveBy(1.0, 0, 168)
		cc.p(320, 532)[2] = cca.fadeOut(1.2)
		cc.p(320, 532)[3] = cca.fadeOut(1.2)
		cc.p(320, 532)[4] = cca.fadeOut(1.2)
		materialLabel[1] = cca.spawn(cc.p(320, 532))
		materialLabel[2] = cca.delay(1.0)
		materialLabel[3] = cca.callFunc(function()
			materialLabel:removeFromParent()
		end)
		materialLabel[4] = cca.callFunc(function()
			materialLabel:removeFromParent()
		end)
		materialLabel[5] = cca.callFunc(function()
			materialLabel:removeFromParent()
		end)
		materialLabel[6] = cca.callFunc(function()
			materialLabel:removeFromParent()
		end)
		local seq = transition.sequence(materialLabel)
		materialLabel:runAction(seq)
	end
	self.Node_mid:setVisible(false)
	SoraDStopEffectNode(self.Node_to)
	SoraDStopEffectNode(self.Node_mid)
	SoraDStopEffectNode(self.Node_from)
	_UPVALUE6_ = self.Node_from
	self.Node_from[1] = cca.callFunc(function()
		SoraDResetEffectNode(self.Node_from)
	end)
	self.Node_from[2] = cca.delay(0.2)
	self.Node_from[3] = cca.callFunc(function()
		self.Node_mid:setVisible(true)
		SoraDResetEffectNode(self.Node_mid)
		lineAct()
		showTip()
	end)
	self.Node_from[4] = cca.delay(0.5)
	self.Node_from[5] = cca.callFunc(function()
		SoraDResetEffectNode(self.Node_to)
	end)
	self.Node_from[6] = cca.delay(0.3)
	self.Node_from[7] = cca.callFunc(function()
		self:initView()
	end)
	self.Node_from[8] = cca.callFunc(function()
		self:initView()
	end)
	local seq = cca.seq(self.Node_from)
	self.Node_mergeEffect:runAction(seq)
end
function MaterialsCompoundView:initView()
	for i, v in ipairs(self.tableMaterialData) do
		self.tableMaterialSinge[i]:initData(v.mid, v.num)
		self.tableMaterialSinge[i]:setHandle(handler(self, self.materialSingeCallBack))
		if self.curMid == v.mid then
			if self.lineLight:getParent() then
				self.lineLight:removeFromParent()
			end
			self.lineLight:addTo(self.tableMaterialSinge[i], -1)
			self.lineLight:setVisible(true)
			self.btnCompound:setVisible(v.num >= 4)
			self.btnCompoundAll:setVisible(v.num >= 4)
			self.labelDes:setVisible(v.num < 4)
		end
	end
	self:setReviewMaterials()
end
function MaterialsCompoundView:setReviewMaterials()
	self.materialFrom:initData(self.curMid)
	local Text_name_from = SoraDGetChildByName(self.materialFrom, "Text_name")
	Text_name_from:setString(itemDesRead.getName(self.curMid))
	Text_name_from:setColor(itemDesRead.getColor(self.curMid))
	local Text_num = SoraDGetChildByName(self.materialFrom, "Text_num")
	local ownNum = backpackCtrl:getItemCount(self.curMid)
	Text_num:setString(ownNum .. "/" .. 4)
	Text_num:setColor(4 <= ownNum and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 0))
	self.materialTo:initData(self.toMid)
	local Text_name_to = SoraDGetChildByName(self.materialTo, "Text_name")
	Text_name_to:setString(itemDesRead.getName(self.toMid))
	Text_name_to:setColor(itemDesRead.getColor(self.toMid))
end
function MaterialsCompoundView:setToMid(mid)
	if equipmentltCtrl.getMaterialIDOfMerge(mid) then
		self.toMid = mid
		self.curMid = equipmentltCtrl.getMaterialIDOfMerge(self.toMid)
		self:initView()
	else
		SoraDShowMsgTip(i18n("common_text_1353"), itemDesRead.getIcon(mid, true))
	end
end
function MaterialsCompoundView:materialSingeCallBack(mid)
	if equipmentltCtrl.getMaterialIDAfterMerge(mid) then
		self.curMid = mid
		self.toMid = equipmentltCtrl.getMaterialIDAfterMerge(self.curMid)
		self:initView()
	else
		SoraDShowMsgTip(i18n("common_text_4291"), itemDesRead.getIcon(mid, true))
	end
end
function MaterialsCompoundView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound("uicontrol", 6)
		if button == self.btnCompoundAll then
			equipmentCtrl:mergeMaterialAsPossible(self.toMid)
		else
			equipmentCtrl:mergeMaterial(self.toMid)
		end
	end
end
function MaterialsCompoundView:onExitPanel()
	self.lineLight:release()
	display.removeAnimationCache("mergeAnimation")
end
function MaterialsCompoundView:addMergeEffect()
	local delay = 1
	for i, v in ipairs(self.tableArrow) do
		v:stopAllActions()
		v:setOpacity(self.tableArrowOpacity[i])
		_UPVALUE3_ = nil
		;(nil)[1] = cca.delay((i - 1) * 0.2 * delay)
		;(nil)[2] = cca.fadeTo(0.1 * delay, self.tableArrowOpacity[i])
		;(nil)[3] = cca.delay((#self.tableArrow - i) * 0.2 * delay + 0.3 * delay)
		;(nil)[4] = cca.fadeTo(0.2 * delay, 0)
		;(nil)[5] = cca.fadeTo(0.2 * delay, 0)
		;(nil)[6] = cca.fadeTo(0.2 * delay, 0)
		v:runAction(cca.repeatForever(cca.seq(nil)))
	end
end
return MaterialsCompoundView
