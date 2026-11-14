local newTrialRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	newTrialRead:defineValue("challengeLvConfig", function()
		_ENV, _ENV = nil, nil
		;(nil).name = "devilvalley_btn_03"
		;(nil).color = cc.c3b(215, 195, 155)
		;(nil).darkcolor = cc.c3b(161, 161, 161)
		;(nil).btnbg = "btn_mgyzz_jd_01.png"
		_ENV, (nil)[0], (nil).bg = nil, nil, "bg_mgyzz_jd.png"
		;(nil).name = "devilvalley_btn_04"
		;(nil).color = cc.c3b(255, 255, 255)
		;(nil).darkcolor = cc.c3b(161, 161, 161)
		;(nil).btnbg = "btn_mgyzz_jd_01.png"
		;(nil).bg = "bg_mgyzz_jd.png"
		_ENV, (nil)[1], (nil).rankbtnbg = nil, nil, "btn_mgyzz_jd.png"
		;(nil).name = "common_text_2697"
		;(nil).color = cc.c3b(162, 255, 129)
		;(nil).darkcolor = cc.c3b(146, 204, 126)
		;(nil).btnbg = "btn_mgyzz_pt_01.png"
		;(nil).bg = "bg_mgyzz_pt.png"
		_ENV, (nil)[2], (nil).rankbtnbg = nil, nil, "btn_mgyzz_pt.png"
		;(nil).name = "devilvalley_btn_06"
		;(nil).color = cc.c3b(106, 218, 255)
		;(nil).darkcolor = cc.c3b(121, 183, 204)
		;(nil).btnbg = "btn_mgyzz_kn_01.png"
		;(nil).bg = "bg_mgyzz_kn.png"
		_ENV, (nil)[3], (nil).rankbtnbg = nil, nil, "btn_mgyzz_kn.png"
		;(nil).name = "devilvalley_btn_07"
		;(nil).color = cc.c3b(195, 131, 255)
		;(nil).darkcolor = cc.c3b(211, 158, 224)
		;(nil).btnbg = "btn_mgyzz_em_01.png"
		;(nil).bg = "bg_mgyzz_em.png"
		_ENV, (nil)[4], (nil).rankbtnbg = nil, nil, "btn_mgyzz_em.png"
		;(nil).name = "devilvalley_btn_08"
		;(nil).color = cc.c3b(255, 134, 68)
		;(nil).darkcolor = cc.c3b(221, 137, 92)
		;(nil).btnbg = "btn_mgyzz_dy_01.png"
		;(nil).bg = "bg_mgyzz_dy.png"
		_ENV, (nil)[5], (nil).rankbtnbg = nil, nil, "btn_mgyzz_dy.png"
		;(nil).name = "devilvalley_btn_19"
		;(nil).color = cc.c3b(255, 0, 0)
		;(nil).darkcolor = cc.c3b(204, 126, 126)
		;(nil).btnbg = "btn_mgyzz_ly_01.png"
		;(nil).bg = "bg_mgyzz_ly.png"
		_ENV, (nil)[6], (nil).rankbtnbg = nil, nil, "btn_mgyzz_ly.png"
		;(nil).name = "devilvalley_btn_20"
		;(nil).color = cc.c3b(255, 68, 116)
		;(nil).darkcolor = cc.c3b(255, 220, 235)
		;(nil).btnbg = "bg_mgyzz_ly2_01.png"
		;(nil).bg = "bg_mgyzz_ly2.png"
		_ENV, (nil)[7], (nil).rankbtnbg = nil, nil, "btn_mgyzz_ly2.png"
		;(nil).name = "devilvalley_btn_21"
		;(nil).color = cc.c3b(255, 68, 116)
		;(nil).darkcolor = cc.c3b(255, 220, 235)
		;(nil).btnbg = "bg_mgyzz_ly2_01.png"
		;(nil).bg = "bg_mgyzz_ly2.png"
		_ENV, (nil)[8], (nil).rankbtnbg = nil, nil, "btn_mgyzz_ly2.png"
		;(nil).name = "devilvalley_btn_22"
		;(nil).color = cc.c3b(255, 68, 116)
		;(nil).darkcolor = cc.c3b(255, 220, 235)
		;(nil).btnbg = "bg_mgyzz_ly2_01.png"
		;(nil).bg = "bg_mgyzz_ly2.png"
		;(nil)[9], (nil).rankbtnbg = nil, "btn_mgyzz_ly2.png"
		return nil
	end)
	newTrialRead:defineValue("showCount", function()
		newTrialRead.showCount = table.nums(newTrialRead.challengeLvConfig) - 1
		return newTrialRead.showCount
	end)
	function _ENV()
		newTrialRead.showCount = table.nums(newTrialRead.challengeLvConfig) - 1
		return newTrialRead.showCount
	end
	;(function()
		newTrialRead.showCount = table.nums(newTrialRead.challengeLvConfig) - 1
		return newTrialRead.showCount
	end)[1] = "devilvalley_config"
	;(function()
		newTrialRead.showCount = table.nums(newTrialRead.challengeLvConfig) - 1
		return newTrialRead.showCount
	end)[2] = true
	newTrialRead:defineValue("devilvalley_config", function()
		newTrialRead.showCount = table.nums(newTrialRead.challengeLvConfig) - 1
		return newTrialRead.showCount
	end)
	if not IsArClient then
		newTrialRead.challengeLvConfig[8] = nil
	end
end
init()
function newTrialRead.getChallengeInfo(challengeLv)
	return newTrialRead.challengeLvConfig[challengeLv]
end
function newTrialRead.getProperty(challengeLv, str)
	local info = newTrialRead.getChallengeInfo(challengeLv)
	if info then
		return info[str]
	end
end
function newTrialRead.getName(challengeLv)
	local info = newTrialRead.getChallengeInfo(challengeLv)
	if info then
		return i18n(info.name)
	end
	return ""
end
function newTrialRead.getReward(challengeLv)
	local config = newTrialRead.devilvalley_config[challengeLv]
	if config and config.Reward then
		return config.Reward
	end
end
function newTrialRead.getCastleCondition(challengeLv)
	local config = newTrialRead.devilvalley_config[challengeLv]
	if config and config.CastleCondition then
		return config.CastleCondition
	end
end
return newTrialRead
