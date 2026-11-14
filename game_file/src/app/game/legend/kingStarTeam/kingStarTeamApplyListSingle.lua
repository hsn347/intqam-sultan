local gametop = gModuleMgr.getObject("gametop")
local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
local teamDef = include("teamDef")
local legendTeamDef = include("legendTeamDef")
local scrollNode = include("scrollNode")
local kingStarTeamApplyListSingle = class("kingStarTeamApplyListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingStarTeamApplyListSingle")
	end
	return target
end)
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function kingStarTeamApplyListSingle:ctor()
	self.teamData, _ENV, self.memberList, _ENV = nil, nil, nil, nil
	self.txtCount = SoraDGetChildByName(self, "Text_armyCount")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.btnJoin = SoraDGetChildByName(self, "Button_join")
	self.btnJoin = scrollNode.new(self.btnJoin)
	self.btnJoin:setSwallowTouches(false)
	self.btnJoin:setTitleText(i18n("remains_btn_05"))
	SoraDAutoSizeButtonTextByContent(self.btnJoin)
	self.btnJoin:addTouchEventListener(handler(self, self.btnJoinClickCallBack))
	self.nodeTouch = SoraDGetChildByName(self, "Panel_touch")
	self.nodeTouch = scrollNode.new(self.nodeTouch)
	self.nodeTouch:setSwallowTouches(false)
	self.nodeTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.nodeMember = SoraDGetChildByName(self, "Panel_member")
	self.imgArr = SoraDGetChildByName(self, "Sprite_arr")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelNum = SoraDGetChildByName(self, "Text_member")
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.imgContent = SoraDGetChildByName(self, "Image_content")
	self.imgContentbg = SoraDGetChildByName(self, "Image_bg_noSize")
	self.txtTips = SoraDGetChildByName(self, "Text_tips")
	self.txtTips:setString(i18n("free_team_text_23"))
	self.handle = nil
	self.memberHeight = 0
	self.btnJoinHeight = 80
	self.launched = false
	self.listNode, _ENV, self.scrollItems, _ENV, self.initMemberView = self.txtTips.setString, self.txtTips.setString, self.txtTips.setString, self.txtTips.setString, false
end
function kingStarTeamApplyListSingle:resetData()
	self:setLaunched(false)
	self.initMemberView = false
end
function kingStarTeamApplyListSingle:initData(data, isLegend)
