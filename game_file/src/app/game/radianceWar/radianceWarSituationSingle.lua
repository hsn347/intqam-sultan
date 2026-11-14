local gametop = gModuleMgr.getObject("gametop")
local radianceWarCtrl = gametop.playertop_:getModule("radianceWarCtrl")
local radianceWarRead = include("radianceWarRead")
local radianceWarUtil = include("radianceWarUtil")
local radianceWarSituationSingle = class("radianceWarSituationSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("radianceWarSituationSingle")
	end
	return target
end)
function radianceWarSituationSingle:ctor()
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setTouchEnabled(false)
	self.btnSelect = SoraDGetChildByName(self, "Button_select")
	self.labelState = SoraDGetChildByName(self, "Text_state")
	self.labelPower = SoraDGetChildByName(self, "Text_power")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelSpeed = SoraDGetChildByName(self, "Text_speed")
	self.labelCount = SoraDGetChildByName(self, "Text_count")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.spriteRes = SoraDGetChildByName(self, "Sprite_res")
	SoraDChangeTextToHtml(self.labelPower)
	self.labelPower:setTouchEnabled(true)
	self.labelPower:addTouchEventListener(handler(self, self.btnClickText))
	self.btnSelect:addTouchEventListener(handler(self, self.btnClickCallBack))
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
end
function radianceWarSituationSingle:openTimeUp()
	if self.curTab and self.curTab == 1 and self.tableSingleData and self.tableSingleData.lastCollSpeed then
		local curCount = radianceWarUtil.getResCount(self.tableSingleData)
		curCount = math.floor(curCount * 100) / 100
		if curCount < 0 then
			curCount = 0
		end
		radianceWarUtil = nil
		;(nil).num = string.formatnumberthousands(string.format("%.2f", curCount))
		self.labelCount:setString(i18n("brightWar_text_84", nil))
		if self.rank == gWorldTypeServerDef.subMapTypeRadianceWarResAmberMine then
			_UPVALUE2_ = self.labelCount
			self.labelCount[1] = self.labelCount
			self.labelCount[2] = self.spriteRes
			_ENV = self.spriteRes
			self.spriteRes[1] = 10
			_G.SoraDAlignNodeArrayOnBeginX(self.labelCount:getPositionX(), self.labelCount, SoraDFIsRA(), self.spriteRes)
		end
	elseif self.curTab and self.curTab == 2 and self.tableSingleData.finishFreeTime then
		local leftTime = math.max(0, self.tableSingleData.finishFreeTime - serviceFunctions.systemTime())
		self.labelState:setString(SoraDConvertSecondToString(leftTime))
	end
end
function radianceWarSituationSingle:setScroll(scroll)
	self.scroll = scroll
end
function radianceWarSituationSingle:setHandle(handle)
	self.handle = handle
end
function radianceWarSituationSingle:initData(rank, singleData, curTab)
	self.tableSingleData = singleData
	self.rank = rank
	self.curTab = curTab
	_ENV = ","
	;(",").u = "true"
	self.labelPower:setString(SoraDWrapHtmlTagByStyle(self.tableSingleData.x - gPointClientPointPlus .. "," .. self.tableSingleData.y - gPointClientPointPlus, ","))
	self.btnSelect:setVisible(not self.tableSingleData.mapType or self.tableSingleData.mapType ~= gMapObjTypeDef.mapTypeRadianceWarGate)
	if self.curTab == 1 then
		self.labelCount:setVisible(true)
		self.labelSpeed:setVisible(true)
		self.labelState:setVisible(false)
		self.btnSelect:loadTextures("btn_red_small_01.png", "", "", ccui.TextureResType.plistType)
		self.btnSelect:setTitleText(i18n("common_text_3626"))
		self.spriteIcon:setScale(0.7)
		if self.rank == 2 then
			self.spriteIcon:setScale(0.6)
		end
		self.spriteIcon:setSpriteFrame(radianceWarRead.getResourceImageName(self.tableSingleData.objId))
		self.labelName:setPositionY(-33.25)
		_ENV = radianceWarRead.getResourceImageName(self.tableSingleData.objId)
		radianceWarRead.getResourceImageName(self.tableSingleData.objId).level = radianceWarRead.getResourceLevel(self.tableSingleData.objId)
		radianceWarRead.getResourceImageName(self.tableSingleData.objId).resName = radianceWarRead.getResourceName(self.tableSingleData.objId)
		self.labelName:setString(i18n("common_text_472", radianceWarRead.getResourceImageName(self.tableSingleData.objId)))
		local lastCollSpeedH = math.floor(3600 * self.tableSingleData.lastCollSpeed * 100 + 0.5) / 100
		_ENV = i18n("common_text_472", radianceWarRead.getResourceImageName(self.tableSingleData.objId))
		i18n("common_text_472", radianceWarRead.getResourceImageName(self.tableSingleData.objId)).num = string.formatnumberthousands(string.format("%.2f", lastCollSpeedH)) .. "/h"
		self.labelSpeed:setString(i18n("brightWar_text_85", i18n("common_text_472", radianceWarRead.getResourceImageName(self.tableSingleData.objId))))
		if self.rank == gWorldTypeServerDef.subMapTypeRadianceWarResAmberMine then
			self.spriteRes:setVisible(true)
		else
			self.spriteRes:setVisible(false)
		end
		self:openTimeUp()
	elseif self.curTab == 2 then
		self.labelCount:setVisible(false)
		self.spriteRes:setVisible(false)
		self.labelSpeed:setVisible(false)
		self.spriteIcon:setScale(1.7)
		self.spriteIcon:setSpriteFrame(radianceWarRead.getBuildIcon(self.tableSingleData.mapType))
		self.labelName:setPositionY(-66.5)
		self.labelName:setString(radianceWarRead.getBuildName(self.tableSingleData.mapType, self.tableSingleData.id))
		if self.tableSingleData.finishFreeTime then
			self.labelState:setVisible(true)
			self.btnSelect:loadTextures("btn_yellow_small_01.png", "", "", ccui.TextureResType.plistType)
			self.btnSelect:setTitleText(i18n("common_text_184"))
			self:openTimeUp()
		else
			self.labelState:setVisible(false)
			self.btnSelect:loadTextures("btn_red_small_01.png", "", "", ccui.TextureResType.plistType)
			self.btnSelect:setTitleText(i18n("common_text_3626"))
		end
	end
	self.isHiddle = false
end
function radianceWarSituationSingle:btnClickText(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isInRadiance() then
			SoraDGotoWorldMapPoint(cc.p(self.tableSingleData.x - gPointClientPointPlus, self.tableSingleData.y - gPointClientPointPlus), true)
			SoraDRemoveAllPanelFromManager()
		else
			SoraDShowMsgTip(i18n("brightWar_text_79"))
		end
	end
end
function radianceWarSituationSingle:setHiddle()
	self.isHiddle = true
end
function radianceWarSituationSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.isHiddle then
			return
		end
		local curid = self.tableSingleData.id
		SoraDPlaySound()
		if self.tableSingleData.finishFreeTime then
			radianceWarCtrl:reqRadianceWarCancelFreeBeacon(self.tableSingleData.id)
			SoraDShowLoading()
		else
			_ENV = nil
			;(nil).name = self.labelName:getString()
			SoraDShowMsgBox(i18n("brightWar_text_58", nil), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
				if MSGBOX_CALLBACK_YES == eventType then
					if curid ~= self.tableSingleData.id or self.tableSingleData.finishFreeTime then
						SoraDShowMsgTip(i18n("notice_0026"))
					else
						if self.curTab == 1 then
							radianceWarCtrl:reqRadianceWarFreeRes(self.tableSingleData.id)
						else
							radianceWarCtrl:reqRadianceWarFreeBeacon(self.tableSingleData.id)
						end
						SoraDShowLoading()
					end
				end
			end)
		end
	end
end
return radianceWarSituationSingle
