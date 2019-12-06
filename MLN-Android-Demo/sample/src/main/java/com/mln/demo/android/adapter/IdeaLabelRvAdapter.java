package com.mln.demo.android.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.mln.demo.R;
import com.mln.demo.android.entity.InspirHotEntity;
import com.mln.demo.mln.common.LoadWithTextView;

import java.util.ArrayList;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

/**
 * Created by xu.jingyu
 * DateTime: 2019-11-08 15:22
 */
public class IdeaLabelRvAdapter extends RecyclerView.Adapter<IdeaLabelRvAdapter.LabelViewHolder> {

    private final LoadWithTextView loadView;
    private Context context;
    public List<InspirHotEntity> list0;

    public IdeaLabelRvAdapter(Context context) {
        this.context = context;
        list0 = new ArrayList<>();
        loadView = new LoadWithTextView(context);
    }

    public void updateList(List<InspirHotEntity> data) {
        list0.clear();
        list0.addAll(data);
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public LabelViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.idea_labels_item, null);
        LabelViewHolder viewHolder = new LabelViewHolder(view);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull LabelViewHolder holder, int position) {
        InspirHotEntity item = list0.get(position);
        holder.tvLabel.setText(item.getName());
    }

    @Override
    public int getItemCount() {
        return list0.size();
    }

    public class LabelViewHolder extends RecyclerView.ViewHolder {

        TextView tvLabel;

        public LabelViewHolder(@NonNull View itemView) {
            super(itemView);
            tvLabel = itemView.findViewById(R.id.tv_label);
        }
    }

}
