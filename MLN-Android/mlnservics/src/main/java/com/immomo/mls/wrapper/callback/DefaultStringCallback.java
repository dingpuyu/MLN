/**
  * Created by MomoLuaNative.
  * Copyright (c) 2019, Momo Group. All rights reserved.
  *
  * This source code is licensed under the MIT.
  * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
  */
package com.immomo.mls.wrapper.callback;

import com.immomo.mls.wrapper.IJavaObjectGetter;

import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaFunction;
import org.luaj.vm2.LuaValue;

/**
 * Created by Xiong.Fangyu on 2019/3/21
 *
 * 封装{@link org.luaj.vm2.LuaFunction}的接口
 *
 * 原始回调Lua方法，返回值为String类型
 */
public class DefaultStringCallback implements IStringCallback {

    private LuaFunction luaFunction;

    public DefaultStringCallback(LuaFunction f) {
        luaFunction = f;
    }

    public static final IJavaObjectGetter<LuaFunction, IStringCallback> G = new IJavaObjectGetter<LuaFunction, IStringCallback>() {
        @Override
        public DefaultStringCallback getJavaObject(LuaFunction lv) {
            return new DefaultStringCallback(lv) ;
        }
    };

    @Override
    public String callback(Object... params) throws IllegalStateException {
        Utils.check(luaFunction);
        LuaValue[] r = Utils.invoke(luaFunction, params);
        if (r.length == 0)
            throw new IllegalStateException(luaFunction.getInvokeError());
        return r[0].toJavaString();
    }

    @Override
    public String callbackAndDestroy(Object... params) throws IllegalStateException {
        Utils.check(luaFunction);
        LuaValue[] r = Utils.invoke(luaFunction, params);
        if (r.length == 0)
            throw new IllegalStateException(luaFunction.getInvokeError());
        luaFunction.destroy();
        luaFunction = null;
        return r[0].toJavaString();
    }

    @Override
    public void destroy() {
        if (luaFunction != null)
            luaFunction.destroy();
        luaFunction = null;
    }

    @Override
    public Globals getGlobals() {
        return luaFunction != null ? luaFunction.getGlobals() : null;
    }
}