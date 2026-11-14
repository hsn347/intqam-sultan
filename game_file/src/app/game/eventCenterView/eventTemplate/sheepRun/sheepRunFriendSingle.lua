local gametop = gModuleMgr.getObject("gametop")
local contactCtrl = gametop.playertop_:getModule("contactCtrl")
local sheepRunCtrl = gametop.playertop_:getModule("sheepRunCtrl")
local buildLogic = include("buildLogic")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local constantRead = include("constantRead")
local sheepRunFriendSingle = class("sheepRunFriendSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sheepRunFriendSingle")
	end
	return target
end)
function sheepRunFriendSingle:ctor()
	self.friendHelpCount = constantRead.getConstValue("RUNNINGSHEEP_INVITED_EACH", 3)
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.ccs_head:setScale(1.0)
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_totalFc = SoraDGetChildByName(self, "Text_text")
	self.Text_got = SoraDGetChildByName(self, "Text_got")
	self.Image_got = SoraDGetChildByName(self, "Image_got")
	self.btn_choose = SoraDGetChildByName(self, "Button_receive")
	self.btn_choose:setSwallowTouches(false)
	self.btn_choose:addTouchEventListener(handler(self, self.onChooseClick))
	self.btn_choose:setTitleText(i18n("common_text_189"))
	self.Text_got:setString(i18n("remains_btn_15"))
end
function sheepRunFriendSingle:initView()
end
function sheepRunFriendSingle:initData(data, otherData)
	self.data = data
	self.curUid = otherData.curUid
	self.scroll = otherData.scroll
	self.ccs_head:setHeadSprite(self.data.headid or self.data.iconID, self.data.avatar)
	self.ccs_head:setPlayerID(self.data.uid)
	self.ccs_head:setKid(self.data.kid or self.data.sourceKid)
	self.ccs_head:setScroll(self.scroll)
	local trasnWarLv = function(clv)
		local warLv = buildLogic.transformBuildLvToWarLv(clv)
		if 0 < warLv then
			buildLogic = nil
			;(nil).lv = warLv
			return i18n("common_text_1948", nil)
		else
			return math.min(clv, CASTLE_MAXLV_NOWAR)
		end
	end
	dump(data, "sheepRunFriendSingle")
	local abbr = self.data.allianceAbbr or self.data.abbr
	local name = self.data.remarkName or self.data.nickName or self.data.name
	local showName = ""
	if abbr and abbr ~= "" then
		buildLogic = nil
		;(nil).abbr = abbr
		;(nil).name = name
		showName = string.format("%s #%d", i18n("common_text_186", nil), self.data.kid or self.data.sourceKid)
	else
		showName = string.format("%s #%d", name, self.data.kid or self.data.sourceKid)
	end
	local retString, label = SoraDConvertOmissionText(220, showName, 22)
	self.Text_name:setString(retString)
	buildLogic = nil
	;(nil).count = string.formatnumberthousands(data.totalFc)
	self.Text_totalFc:setString(i18n("common_text_555", nil))
	local isCurIdx = self.curUid == self.data.uid
	self.btn_choose:setVisible(not isCurIdx)
	self.Image_got:setVisible(isCurIdx)
	self.Text_got:setVisible(isCurIdx)
end
function sheepRunFriendSingle:onChooseClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		SoraDPlaySound()
		if sheepRunCtrl:getFriendHelpCount(self.data.uid) >= self.friendHelpCount then
			_ENV = nil
			;(nil).var = self.friendHelpCount
			SoraDShowMsgTip(i18n("runningSheep_text_14", nil))
			return
		end
		if self.curUid ~= nil and self.curUid ~= self.data.uid and sheepRunCtrl:getCurContactData() then
			local contactData = sheepRunCtrl:getCurContactData()
			_ENV = i18n("runningSheep_text_14", nil)
			i18n("runningSheep_text_14", nil).name1 = contactData.name
			i18n("runningSheep_text_14", nil).name2 = self.data.name
			local tip = i18n("runningSheep_text_16", i18n("runningSheep_text_14", nil))
			SoraDShowMsgBoxNew(tip, nil, nil, function(exitType, other)
				if exitType ~= MSGBOX_CALLBACK_YES then
					return
				end
				sheepRunCtrl:reqChooseFriend1(self.data.uid)
			end)
			return
		end
		sheepRunCtrl:reqChooseFriend1(self.data.uid)
	end
end
return sheepRunFriendSingle
