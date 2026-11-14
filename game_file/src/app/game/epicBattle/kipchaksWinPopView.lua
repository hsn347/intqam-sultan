local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local buildDescribeRead = include("buildDescribeRead")
local publicRead = include("publicRead")
local kipchaksWinPopView = class("kipchaksWinPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("kipchaksWinPopView")
	end
	return target
end)
function kipchaksWinPopView:ctor()
	self.data = nil
	self.starArray, _ENV, self.receiveAll = nil, nil, nil
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("epicbattle_text_16"))
	_UPVALUE2_, self.Node_pass = SoraDGetChildByName(self, "Node_pass"), SoraDGetChildByName(self, "Node_pass")
	SoraDGetChildByName(self, "Node_pass")[1] = i18n("epicbattle_text_53")
	SoraDGetChildByName(self, "Node_pass")[2] = i18n("epicbattle_text_54")
	SoraDGetChildByName(self, "Node_pass")[3] = i18n("epicbattle_text_55")
	SoraDGetChildByName(self, "Node_pass")[4] = i18n("epicbattle_text_55")
	SoraDGetChildByName(self, "Node_pass")[5] = i18n("epicbattle_text_55")
	SoraDGetChildByName(self, "Node_pass")[6] = i18n("epicbattle_text_55")
	SoraDGetChildByName(self, "Node_pass")[7] = i18n("epicbattle_text_55")
	SoraDGetChildByName(self, "Node_pass")[8] = i18n("epicbattle_text_55")
	SoraDGetChildByName(self, "Node_pass")[9] = i18n("epicbattle_text_55")
	local SoraDGetChildByName(self, "Node_pass")[10], desConfig = i18n("epicbattle_text_55")
	for i = 1, 3 do
		local starNode = SoraDGetChildByName(self.Node_pass, "Node_star_" .. i)
		local star = starNode:getChildByName("icon_star")
		local des = starNode:getChildByName("Text_des")
		des:setString(desConfig[i])
		_ENV = des
		des.star = star
		self.starArray[i], des.des = des, des
	end
	self.Node_pass:setVisible(false)
	self.Node_star = SoraDGetChildByName(self, "Node_star")
	self.Node_star:setVisible(false)
	self.Node_awardShow = SoraDGetChildByName(self, "Node_awardShow")
	self.Node_spine = SoraDGetChildByName(self, "Node_spine")
	local spine_lost = sp.SkeletonAnimation:create("spine/shengli.skel", "spine/shengli.atlas", 1)
	spine_lost:addTo(self.Node_spine)
	spine_lost:setAnimation(0, "animation", true)
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.onBtnOKClick))
	self.Button_look = SoraDGetChildByName(self, "Button_look")
	self.Button_look:setTitleText(i18n("common_text_829"))
	self.Button_look:addTouchEventListener(handler(self, self.onBtnLookClick))
end
function kipchaksWinPopView:initData(data)
	self.data = data
	self.bossData = buildDescribeRead.getkipchaks(self.data.npcLv)
	if not self.bossData.reward then
		local buildDescribeRead, reward = self.bossData.reward, self.bossData.reward
	end
	for i = 1, 4 do
		local awardItem = SoraDGetChildByName(self, "Node_award_" .. i)
		local sprite_item = SoraDGetChildByName(awardItem, "sprite_item")
		local Text_ItemName = SoraDGetChildByName(awardItem, "Text_ItemName")
		local Text_num = SoraDGetChildByName(awardItem, "Text_num")
		local itemID = reward[2 * i - 1]
		local itemNum = reward[2 * i]
		if itemID then
			sprite_item:setSpriteFrame(publicRead.getIcon(itemID))
			Text_ItemName:setString(publicRead.getName(itemID))
			Text_num:setString(string.formatnumberthousands(itemNum))
		else
			awardItem:setVisible(false)
			sprite_item:setSpriteFrame("icon_equip_storagebox.png")
			Text_ItemName:setString(i18n("common_text_486"))
		end
		sprite_item:setScale(95.03999999999999 / sprite_item:getContentSize().width)
	end
	SoraDToCenter(self.Node_awardShow, 140)
end
function kipchaksWinPopView:onBtnOKClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function kipchaksWinPopView:onBtnLookClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("kipchaksReport")
		panel:initData(self.data)
		panel:show()
	end
end
return kipchaksWinPopView
