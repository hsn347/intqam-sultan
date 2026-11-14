local mailNodeFactory = include("mailNodeFactory")
local mailWrathBeastAward = class("mailWrathBeastAward", function(target)
	return ccui.Layout:create()
end)
function mailWrathBeastAward:ctor()
	self:setSwallowTouches(false)
	self:setCascadeOpacityEnabled(true)
	self:setLayoutType(ccui.LayoutType.VERTICAL)
end
function mailWrathBeastAward:initWithData(data, view)
	local content = data.content
	local playerAtkReward = content.playerAtkReward
	local fatalRewardArr = content.fatalRewardArr
	local endBlowReward = content.endBlowReward
	local luckyBlowReward = content.luckyBlowReward
	local turnsBlowReward = content.turnsBlowReward
	local resultLevel = content.resultLevel or 1
	_UPVALUE3_, self.view = nil, view
	_ENV, _ENV, (nil)[1] = "title_yjyh_great%s.png", "title_yjyh_good%s.png", "title_yjyh_good%s.png"
	_ENV, _ENV, (nil)[2] = "title_yjyh_great%s.png", "title_yjyh_good%s.png", "title_yjyh_great%s.png"
	local _ENV, _ENV, (nil)[3], resultStr = "title_yjyh_great%s.png", "title_yjyh_good%s.png", "title_yjyh_perfect%s.png", nil
	_ENV, ("title_yjyh_good%s.png")[1], ("title_yjyh_great%s.png").str = "title_yjyh_great%s.png", "title_yjyh_great%s.png", "title_yjyh_zhuanyunyiji%s.png"
	_ENV, ("title_yjyh_good%s.png")[2], ("title_yjyh_great%s.png").str = "title_yjyh_great%s.png", "title_yjyh_great%s.png", "title_yjyh_xingyunyiji%s.png"
	_ENV, ("title_yjyh_good%s.png")[3], ("title_yjyh_great%s.png").str = "title_yjyh_great%s.png", "title_yjyh_great%s.png", "title_yjyh_zhongjieyiji%s.png"
	_ENV, ("title_yjyh_good%s.png")[4], ("title_yjyh_great%s.png").str = "title_yjyh_great%s.png", "title_yjyh_great%s.png", "title_yjyh_zhimingyiji%s.png"
	self.config, ("title_yjyh_good%s.png")[5], ("title_yjyh_great%s.png").str = "title_yjyh_good%s.png", "title_yjyh_great%s.png", resultStr[resultLevel]
	local totalHeight = 0
	_UPVALUE5_ = resultStr[resultLevel]
	resultStr[resultLevel][1] = "turnsBlowReward"
	resultStr[resultLevel][2] = "luckyBlowReward"
	resultStr[resultLevel][3] = "endBlowReward"
	resultStr[resultLevel][4] = "fatalRewardArr"
	resultStr[resultLevel][5] = "playerAtkReward"
	for i, v in ipairs(resultStr[resultLevel]) do
		local rewards = content[v]
		if rewards and next(rewards) then
			if v == "fatalRewardArr" then
				for __, n in ipairs(rewards) do
					local height = self:createSingle(i, n)
					totalHeight = totalHeight + height
				end
			else
				local height = self:createSingle(i, rewards)
				totalHeight = totalHeight + height
			end
		end
	end
	self.itemWidth = gMailDetaiViewWidth
	self.itemHeight = totalHeight
	self:setContentSize(cc.size(self.itemWidth, self.itemHeight))
end
function mailWrathBeastAward:createSingle(index, rewards)
	local single, autoHeight = mailNodeFactory:creatRewardCustomNode(rewards, 5)
	local img_bg = ccui.ImageView:create()
	img_bg:loadTexture(string.format(self.config[index].str, SoraDFIsRA() and "" or "_en"), ccui.TextureResType.plistType)
	single:addChild(img_bg)
	img_bg:setAnchorPoint(cc.p(1, 1))
	img_bg:setPosition(cc.p(gMailDetaiViewWidth - 20, autoHeight))
	single:addTo(self)
	return autoHeight
end
function mailWrathBeastAward:getItemWidth()
	return self.itemWidth
end
function mailWrathBeastAward:getItemHeight()
	return self.itemHeight
end
return mailWrathBeastAward
