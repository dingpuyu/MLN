package com.mln.demo.mln.common;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.immomo.mls.util.DimenUtil;
import com.immomo.mls.weight.load.ILoadWithTextView;
import com.mln.demo.R;

/**
 * Created by XiongFangyu on 2018/7/26.
 */
public class LoadWithTextView extends LinearLayout implements ILoadWithTextView {
    public LoadWithTextView(Context context) {
        this(context, null);
    }

    public LoadWithTextView(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public LoadWithTextView(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private ImageView imageView;
    private TextView textView;

    private void init(Context context) {
        LinearLayout.LayoutParams lp=new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        imageView =new ImageView(context);
        imageView.setLayoutParams(lp);
        imageView.setBackgroundResource(R.drawable.lv_default_progress);
        imageView.setVisibility(GONE);
        addView(imageView);

        textView=new TextView(context);
        lp.leftMargin= DimenUtil.dpiToPx(6);
        textView.setLayoutParams(lp);
        textView.setSingleLine();
        textView.setTextColor(context.getResources().getColor(R.color.load_color));
        textView.setTextSize(13);
        addView(textView);

        setOrientation(HORIZONTAL);
        setGravity(Gravity.CENTER);
        int dp16 = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 16, getResources().getDisplayMetrics());
        setPadding(dp16, dp16, dp16, dp16);
    }

    @Override
    public void setLoadText(CharSequence text) {
        textView.setText(text);
    }

    @NonNull
    @Override
    public View getView() {
        return this;
    }

    @Override
    public void startAnim() {
        if (imageView.getAnimation() != null)
            return;
        imageView.startAnimation(initAnim());
    }

    @Override
    public void stopAnim() {
        imageView.clearAnimation();
    }

    @Override
    public void showLoadAnimView() {
        imageView.setVisibility(VISIBLE);
    }

    @Override
    public void hideLoadAnimView() {
        imageView.setVisibility(GONE);
    }

    private <T extends View> T findView(int id) {
        return (T) findViewById(id);
    }

    private Animation initAnim() {
        RotateAnimation rotate = new RotateAnimation(0, 360, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        rotate.setDuration(600);
        rotate.setInterpolator(new LinearInterpolator());
        rotate.setRepeatCount(Animation.INFINITE);
        rotate.setRepeatMode(Animation.RESTART);
        return rotate;
    }
}
