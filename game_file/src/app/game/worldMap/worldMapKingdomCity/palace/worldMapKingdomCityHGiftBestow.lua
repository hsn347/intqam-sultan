local worldMapKingdomCityAppointSelect = include("worldMapKingdomCityAppointSelect")
local worldMapKingdomCityHGiftBestow = class("worldMapKingdomCityHGiftBestow", worldMapKingdomCityAppointSelect)
_ENV = "worldMapKingdomCityHGiftBestow"
;("worldMapKingdomCityHGiftBestow").name = 1
local _ENV, ("worldMapKingdomCityHGiftBestow").uid, sortType = worldMapKingdomCityAppointSelect, 2, "worldMapKingdomCityHGiftBestow"
_ENV = nil
worldMapKingdomCityAppointSelect[sortType.name], (nil).name = nil, "common_text_3155"
_ENV = nil
worldMapKingdomCityAppointSelect[sortType.uid], (nil).name = nil, "UID"
local sortTypeList = worldMapKingdomCityAppointSelect
function worldMapKingdomCityHGiftBestow:ctor(...)
	worldMapKingdomCityHGiftBestow.super.ctor(self, ...)
	self.curSortType = sortType.name
	self.keyname = ""
	self.keyuid = ""
	self.keykid = nil
	SoraDGetChildByName(self, "Text_kid"):setString("KID")
	self.txtFieldKid = SoraDGetChildByName(self, "TextField_kid")
	self.txtFieldKid:setTextHorizontalAlignment(SoraDFLabelR())
	self.txtFieldKid:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.txtFieldKid = self:changeToEditBox(self.txtFieldKid)
	self.txtFieldKid:setMaxLength(5)
	self.txtFieldKid:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.txtFieldKid:registerScriptEditBoxHandler(handler(self, self.OnInputChangeByEditBoxEnd))
	self.Button_choose = SoraDGetChildByName(self, "Button_choose")
	self.Button_choose:addTouchEventListener(handler(self, self.onChooseClick))
	self.Button_name = SoraDGetChildByName(self, "Button_name")
	self.Button_name:setTitleText(i18n(sortTypeList[sortType.name].name))
	self.Button_name:addTouchEventListener(handler(self, self.onNameClick))
	self.Button_uid = SoraDGetChildByName(self, "Button_uid")
	self.Button_uid:setTitleText(i18n(sortTypeList[sortType.uid].name))
	self.Button_uid:addTouchEventListener(handler(self, self.onUIDClick))
end
function worldMapKingdomCityHGiftBestow:onChooseClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.switcher = not self.switcher
		self:setSwitcher()
	end
end
function worldMapKingdomCityHGiftBestow:onNameClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.switcher = false
		self.curSortType = sortType.name
		self:setSwitcher()
	end
end
function worldMapKingdomCityHGiftBestow:onUIDClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.switcher = false
		self.curSortType = sortType.uid
		self:setSwitcher()
	end
end
function worldMapKingdomCityHGiftBestow:setSwitcher()
	self.Button_choose:setTitleText(i18n(sortTypeList[self.curSortType].name))
	self.Button_name:setVisible(self.switcher)
	self.Button_uid:setVisible(self.switcher)
end
function worldMapKingdomCityHGiftBestow:btnSearchClickCallBack(button, ttype)
	if ttype == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		self.keyname = self.txtFieldCode:getText()
		self.keyname = string.trim(self.keyname)
		self.keyuid = self.keyname
		self.keykid = tonumber(self.txtFieldKid:getText())
		print("==self.keykid==", self.keykid)
		if not self.keyname or type(self.keyname) ~= "string" then
			return
		end
		if string.utf8len(self.keyname) <= 0 and self.fromSearchStyle ~= nil then
			self.fromSearchStyle = nil
			lordInfoCtrl:searchLordInKingdomReq("", 1, self.searchMode)
			SoraDShowLoading(self)
			return
		elseif string.utf8len(self.keyname) <= 0 then
			return
		end
		if self.curSortType == sortType.name and string.utf8len(self.keyname) > 0 and string.utf8len(self.keyname) < SEARCH_MIN_LEN then
			SoraDShowMsgTip(i18n("common_text_961"))
			return
		end
		if self.searchStyle == gSearchStyle.LORD_ALL_WORLD then
			if self.curSortType == sortType.name then
				lordInfoCtrl:searchLordInThisKingdomReq(self.keyname, 1, self.keykid, nil, self.searchMode)
			else
				lordInfoCtrl:searchLordInThisKingdomReq("", 1, self.keykid, self.keyuid, self.searchMode)
			end
		elseif self.searchStyle == gSearchStyle.LORD_ALL_JOIN then
			if self.curSortType == sortType.name then
				lordInfoCtrl:searchLordAllJoin(self.bid, self.keyname, self.keykid)
			else
				lordInfoCtrl:searchLordAllJoinByUid(self.bid, self.keyuid, self.mapid)
			end
		end
		SoraDShowLoading(self)
	end
end
function worldMapKingdomCityHGiftBestow:OnInputChangeByEditBoxEnd(event, editBox)
	if event == "ended" or event == "return" then
		local oriString = editBox:getText()
		if string.len(oriString) > 0 then
			local kid = tonumber(oriString)
			local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
			if not kid or kid <= 0 or not kingdomCtrl:isFoundKingdomID(kid) then
				editBox:runAction(cca.callFunc(function()
					editBox:setText("")
				end))
			end
		end
	end
end
return worldMapKingdomCityHGiftBestow
