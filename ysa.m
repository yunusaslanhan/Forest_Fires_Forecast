x=input;%giriş değerlerim
w=rand(11,7); % ara katman ağırlıkları 
dw=rand(11,7);%ara katman ağırlıklarındaki değişim
b=rand(11,1); %ara katman biasları
db=zeros (11,1);% ara katman biaslarındaki değişim
o=zeros (11,1); %ara katman çıkışları
wp=rand(2,11); %çıkış katmanı ağırlıkları
dwp=rand(2,11); %çıkış katmanındaki ağırlıkların değişimi
bp=rand(7,1); % çıkış katmanı biasları 
dbp=zeros(2,1) ; %çıkış katmanı biaslarındaki değişim
rp=zeros(2,1); %çıkış faktörü hata faktörleri
y=zeros(2,1); %üretilen çıkışlar
t=output;%hedef çıkışlar

testtarget=testoutput;


for k=1: length(x)
    %%%%%%%%%
    hata=1;
    while(hata>0.08)
        % ara katman çıkışlarının bulunması
        for i=1:11
            top=0;
            for n=1:7
                top=top+x(n,k)*w(i,n);
            end 
            o(i)=ysa_fonksiyon(top+bp(n));
            
        end
        % çıkış katmanı çıkışlarının bulunması
       for n=1:2
           top=0;
           for i =1:11
               top =top+o(i)*wp(n,i);
           end
           y(n)=ysa_fonksiyon(top+bp(n));
       end
      
       %%%%%%%%%%%%%
       % çıkış katmanı hata faktörlerinin hesaplanması
       n=0.01; % öğrenme oranı
       for i=1:2
           rp(i)=(t(i)-y(i))*y(i)*(1-y(i));
       end
       %çıkış ağırlıklarının güncellenmesi
for j=1:2
    for i=1:11
        dwp(j,i)=n*rp(j)*o(1);
    end
end
wp=wp+dwp;
%çıkış katmanı biaslarının güncellenmesi
for j=1:2
    dbp(j)=n*rp(j);
    bp(j)=bp(j)+dbp(j);
end
%%%%
%arakatman ağırlıklarının güncellenmesi
for i=1:11
    for j=1:7
        dw(i,j)=n*o(i)*(1-o(i))*wp(1,i)*rp(1)*x(j,k);
           w(i,j)=w(i,j)+dw(i,j);
         end
end
%arakatman bias güncellenmesi
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
    %ara katmanı çıkışlarının bulunması testi
    for i=1:11
        top=0;
        for n=1:7
            top=top+test(n,k)*w(i,n);
        end
        o(i)=ysa_fonksiyon(top+b(i));
    end
    % çıkış katmanı çıkışlarının bulunması(testt)
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
sprintf('verilen test setine göre basari orani %f dir' , 100*dogru /length(test))