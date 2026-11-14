local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local equipDesRead = include("equipDesRead")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_cSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_cSingle", Com_cSingle)
function Com_cSingle:onInit()
	self.fields.Button_touch:addClickListener(handler(self, self.btnClick))
end
function Com_cSingle:onShow()
end
function Com_cSingle:initData(data, idx, isFromUsing)
	dump(data, "Com_cSingle:initData")
	self.index = data.index
	self.arm = data.arm
	self.divineID = data.divineID
	self.fieldKey = data.fieldKey
	self.iconFrame = data.iconFrame
	self.ctype = data.ctype or self.index
	self.idx = idx
	self.isFromUsing = isFromUsing or false
	if (not self.isFromUsing or not combinationCtrl:getCombinationPreData(self.idx)) and not combinationCtrl:getCombinationData(self.idx) then
		local _ENV, combData = combinationCtrl:getCombinationData(self.idx), combinationCtrl:getCombinationData(self.idx)
	end
	local name = i18n("common_text_480")
	if self.ctype == combinationCtrl.COMBINATION_TYPE.DIVINEBEASTMARK then
		local divineBeastRead = include("divineBeastRead")
		self.fields.icon:setSpriteFrame(divineBeastRead.getCombinationGroupIcon(self.divineID) or "frame_artifact_600131.png")
		if combData.divineBeastMarkSet and combData.divineBeastMarkSet[tostring(self.divineID)] then
			name = divineBeastMarkCtrl:getGroupName(combData.divineBeastMarkSet[tostring(self.divineID)])
		end
	elseif self.arm then
		self.fields.icon:setSpriteFrame(equipDesRead.getArtifactIcon(self.arm.weaponID))
		if combData.godArmsRunes and combData.godArmsRunes[tostring(self.arm.weaponID)] then
			name = godArmsRuneCtrl:getArmGroupName(self.arm.weaponID, combData.godArmsRunes[tostring(self.arm.weaponID)])
		end
	else
		self.fields.icon:setSpriteFrame(self.iconFrame or string.format("icon_zxtq_%02d.png", self.index))
		local setID = self.fieldKey and (tonumber(combData[self.fieldKey]) or 0) or 0
		if 0 < setID then
			name = combinationCtrl:getSetName(self.ctype, setID)
		end
	end
	self.fields.title:setString(name)
end
function Com_cSingle:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_COMBINATION_SET"
	;(nil).idx = self.idx
	;(nil).index = self.index
	_ENV, (nil).ctype = self.ctype, self.ctype
	;(nil).otherData, self.ctype.divineID = self.ctype, self.divineID
	;(nil).weaponID = self.arm and self.arm.weaponID
	;(nil).isFromUsing = self.isFromUsing
	;(nil).pos = self:localToGlobal(cc.p(42, 38))
	SoraDSendMessage(nil)
end
return Com_cSingle
