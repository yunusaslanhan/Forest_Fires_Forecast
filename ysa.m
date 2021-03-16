x=input;%giri� de�erlerim
w=rand(11,7); % ara katman a��rl�klar� 
dw=rand(11,7);%ara katman a��rl�klar�ndaki de�i�im
b=rand(11,1); %ara katman biaslar�
db=zeros (11,1);% ara katman biaslar�ndaki de�i�im
o=zeros (11,1); %ara katman ��k��lar�
wp=rand(2,11); %��k�� katman� a��rl�klar�
dwp=rand(2,11); %��k�� katman�ndaki a��rl�klar�n de�i�imi
bp=rand(7,1); % ��k�� katman� biaslar� 
dbp=zeros(2,1) ; %��k�� katman� biaslar�ndaki de�i�im
rp=zeros(2,1); %��k�� fakt�r� hata fakt�rleri
y=zeros(2,1); %�retilen ��k��lar
t=output;%hedef ��k��lar

testtarget=testoutput;


for k=1: length(x)
    %%%%%%%%%
    hata=1;
    while(hata>0.08)
        % ara katman ��k��lar�n�n bulunmas�
        for i=1:11
            top=0;
            for n=1:7
                top=top+x(n,k)*w(i,n);
            end 
            o(i)=ysa_fonksiyon(top+bp(n));
            
        end
        % ��k�� katman� ��k��lar�n�n bulunmas�
       for n=1:2
           top=0;
           for i =1:11
               top =top+o(i)*wp(n,i);
           end
           y(n)=ysa_fonksiyon(top+bp(n));
       end
      
       %%%%%%%%%%%%%
       % ��k�� katman� hata fakt�rlerinin hesaplanmas�
       n=0.01; % ��renme oran�
       for i=1:2
           rp(i)=(t(i)-y(i))*y(i)*(1-y(i));
       end
       %��k�� a��rl�klar�n�n g�ncellenmesi
for j=1:2
    for i=1:11
        dwp(j,i)=n*rp(j)*o(1);
    end
end
wp=wp+dwp;
%��k�� katman� biaslar�n�n g�ncellenmesi
for j=1:2
    dbp(j)=n*rp(j);
    bp(j)=bp(j)+dbp(j);
end
%%%%
%arakatman a��rl�klar�n�n g�ncellenmesi
for i=1:11
    for j=1:7
        dw(i,j)=n*o(i)*(1-o(i))*wp(1,i)*rp(1)*x(j,k);
           w(i,j)=w(i,j)+dw(i,j);
         end
end
%arakatman bias g�ncellenmesi
for i=1:11
    db(i)=n*o(i)*(1-o(i))*wp(1,i)*rp(1);
    b(i)=b(i)+db(i);
end
hata=(1/2)*((t(1)-y(1))^2+(t(2)-y(2))^2);
    end
end
%%%%%%%%%%%%%%%%%%
dogru=0;
for k=1:length(test)
    %ara katman� ��k��lar�n�n bulunmas� testi
    for i=1:11
        top=0;
        for n=1:7
            top=top+test(n,k)*w(i,n);
        end
        o(i)=ysa_fonksiyon(top+b(i));
    end
    % ��k�� katman� ��k��lar�n�n bulunmas�(testt)
    for n=1:2
        top=0;
        for i=1:11
            top=top+o(i)*wp(n,i);
        end
        y(n)=ysa_fonksiyon(top+bp(n));
    end
    
   for i=1:2
        if y(i)>0.1
            y(i)=1;
        else 
            y(i)=0;
        end
    end 
 
 if( (testtarget(1,k)== y(1))) && (testtarget(2,k)==y(2) )
        dogru=dogru+1;
   end
end
sprintf('verilen test setine g�re basari orani %f dir' , 100*dogru /length(test))