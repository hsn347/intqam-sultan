local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local teamDef = include("teamDef")
local scrollNode = include("scrollNode")
local teamApplyListSingle = class("teamApplyListSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamApplyListSingle")
	end
	return target
end)
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function teamApplyListSingle:ctor()
	self.teamData, _ENV, self.memberList, _ENV = nil, nil, nil, nil
	self.txtCount = SoraDGetChildByName(self, "Text_armyCount")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.btnJoin = SoraDGetChildByName(self, "Button_join")
	self.btnJoin = scrollNode.new(self.btnJoin)
	self.btnJoin:setSwallowTouches(false)
	self.btnJoin:addTouchEventListener(handler(self, self.btnJoinClickCallBack))
	SoraDAutoSizeButtonTextByContent(self.btnJoin)
	self.nodeTouch = SoraDGetChildByName(self, "Panel_touch")
	self.nodeTouch = scrollNode.new(self.nodeTouch)
	self.nodeTouch:setSwallowTouches(false)
	self.nodeTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.nodeMember = SoraDGetChildByName(self, "Panel_member")
	self.imgArr = SoraDGetChildByName(self, "Sprite_arr")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelNum = SoraDGetChildByName(self, "Text_member")
	self.imgBg = SoraDGetChildByName(self, "Image_bg")
	self.handle = nil
	self.memberHeight = 0
	self.btnJoinHeight = 0
	self.launched = false
	self.listNode, _ENV, self.scrollItems, _ENV, self.initMemberView = SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg"), SoraDGetChildByName(self, "Image_bg"), false
end
function teamApplyListSingle:resetData()
	self:setLaunched(false)
	self.initMemberView = false
end
function teamApplyListSingle:initData(data)
