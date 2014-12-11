function [pla,V] = train_dv_vectors(list)

fid = fopen(list, 'rt');
C = textscan(fid, '%s');
C = C{1};
fclose(fid);

fid = fopen('vectorlist','w');
dev_ivs = zeros(200, length(C));

for file = 1 : length(C),
    P = strsplit(char(C(file)),'\\');
    l = length(P);
    s = strcat('vectors\',char(P(l)));
    name = C(file);
    dev_ivs(:,file) = extract_ivector(char(name), 'ubm', 'T',s);
    fprintf(fid,'%s\n',s); 
end

labels = write_labels('vectorlist');
V = lda(dev_ivs, labels);
niter = 10;
lda_dim = 35;
nphi    = lda_dim;
dev_ivs = V(:, 1 : lda_dim)' * dev_ivs;
pla = gplda_em(dev_ivs, labels, nphi, niter);





fclose(fid);