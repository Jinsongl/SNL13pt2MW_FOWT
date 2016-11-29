function plot_members_HydroDyn(file)

% file='.\5MW_Baseline\NRELOffshrBsline5MW_OC4DeepCwindSemi_HydroDyn.dat';
joints=get_memberjoints(file);
members=get_members(file);

%% Joints
figure;plot(joints(:,2),joints(:,3),'.r');
axis equal;grid on;hold on;
plot(joints(9:11,2),joints(9:11,3),'.b');

%% Members
% m1=member(:,2);
% m2=member(:,3);
mpos1=joints(members(:,2),2:4);
mpos2=joints(members(:,3),2:4);
mx=[mpos1(:,1),mpos2(:,1)];
my=[mpos1(:,2),mpos2(:,2)];
mz=[mpos1(:,3),mpos2(:,3)];
% my=joints(members(:,2),3);
% figure;
% axis equal;grid on;
line(mx',my');

figure;
axis equal;grid on;hold on;
line(my',mz');

end

function members=get_members(file)
% file='SNL13pt2_Floating_HydroDyn.dat';
fid=fopen(file);
nLines=0;
while (fgets(fid) ~= -1),
    nLines = nLines+1;
end
fclose(fid);
fid=fopen(file);
i=1;flag=0;
% outlist={'Time'};
% members=0;
while ~feof(fid)
    line   = fgetl( fid );
    if flag==1
        if strcmp(line(1:3),'---')
            break;
        end
        members(i,1)=str2double(line(4:5));
        members(i,2)=str2double(line(14:15));
        members(i,3)=str2double(line(25:26));
        members(i,4)=str2double(line(38));
        members(i,5)=str2double(line(51));
        i=i+1;
    end
    if strcmp(line(1:19),'MemberID  MJointID1')
        flag=1;
        line   = fgetl( fid );
    end
end
end

function joint=get_memberjoints(file)
% file='SNL13pt2_Floating_HydroDyn.dat';
fid=fopen(file);
nLines=0;
while (fgets(fid) ~= -1),
    nLines = nLines+1;
end
fclose(fid);
fid=fopen(file);
l=0;i=1;s=0;flag=0;
% outlist={'Time'};
joint=0;
while ~feof(fid)
    line   = fgetl( fid );
    if flag==1
        if strcmp(line(1:3),'---')
            break;
        end
        joint(i,1)=str2double(line(4:5));
        joint(i,2)=str2double(line(6:17));
        joint(i,3)=str2double(line(18:29));
        joint(i,4)=str2double(line(30:41));
        joint(i,5)=str2double(line(48));
        i=i+1;
    end
    if strcmp(line(1:7),'JointID')
        flag=1;
        line   = fgetl( fid );
    end
end
end